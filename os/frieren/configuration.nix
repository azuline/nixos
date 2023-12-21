{ config, lib, pkgs, pkgs-stable, ... }:

let
  mdadmConf = ''
    HOMEHOST frieren
    ARRAY /dev/md/boot level=raid1 num-devices=2 metadata=1.0 name=frieren:boot UUID=cead52f6:31d93e99:9ddd42fb:38f32893
       devices=/dev/nvme0n1p2,/dev/nvme1n1p2
    ARRAY /dev/md/root level=raid1 num-devices=2 metadata=1.2 name=frieren:root UUID=31e25b0c:782fe16a:b4bb60b0:f2cfbd47
       devices=/dev/nvme0n1p3,/dev/nvme1n1p3
  '';
in
{
  system.stateVersion = "23.11";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.max-jobs = 8;
  nixpkgs.config.allowUnfree = true;
  # Doesn't work in Flakes.
  programs.command-not-found.enable = false;

  imports = [
    ./hardware-configuration.nix
    ./services.nix
  ];

  time.timeZone = "UTC";
  i18n.defaultLocale = "en_US.UTF-8";

  networking = {
    hostName = "frieren";
    useDHCP = false;
    interfaces.eno1.ipv4.addresses = [{ address = "147.135.10.32"; prefixLength = 24; }];
    defaultGateway = "147.135.10.254";
    nameservers = [ "1.1.1.1" ];
    firewall = {
      allowedTCPPorts = [
        22 # ssh
        2222 # boot ssh
        80 # http
        443 # https
      ];
      # For tailscale https://github.com/tailscale/tailscale/issues/4432.
      checkReversePath = "loose";
      interfaces.tailscale0 = {
        allowedTCPPorts = [
          22 # ssh
          4646 # nomad
          8500 # consul
          9001 # thelounge
        ];
      };
    };
  };

  boot = {
    loader = {
      systemd-boot.enable = false;
      efi.canTouchEfiVariables = false;
      grub = {
        enable = true;
        efiSupport = true;
        efiInstallAsRemovable = true;
        enableCryptodisk = true;
        device = "nodev";
      };
      supportsInitrdSecrets = true;
    };
    kernelParams = [ "ip=147.135.10.32::147.135.10.254:255.255.255.0:frieren:eno1:off:1.1.1.1:" ];
    initrd = {
      kernelModules = [ "cryptd" "aesni_intel" "igb" ];
      network = {
        enable = true;
        ssh = {
          enable = true;
          port = 2222; # ssh port during boot for luks decryption; it will have a different host key from post-boot ssh
          authorizedKeys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK7+XlAgpi6eSC0GjgUq1bMOtGOzrOODBTkID8LuuZAL splendor"
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPT/WSwL6oN2JNVy1juCAKk/gJ7KFgPVko3BX0nO3neQ haiqin"
          ];
          hostKeys = [ "/etc/ssh/initrd_ssh_host_ed25519_key" ];
        };
        # Set the shell profile to meet SSH connections with a decryption
        # prompt that writes to /tmp/continue if successful.
        # https://mth.st/blog/nixos-initrd-ssh/
        postCommands = ''
          echo "cryptsetup luksOpen /dev/md/root enc-pv && echo 'done' > /tmp/continue" >> /root/.profile
          echo "starting sshd..."
        '';
      };
      # Block the boot process until /tmp/continue is written to
      # To debug, run /bin/sh here.
      postDeviceCommands = ''
        echo 'waiting for root device to be opened...'
        mkfifo /tmp/continue
        cat /tmp/continue
      '';
      luks = {
        forceLuksSupportInInitrd = true;
      };
      secrets = {
        "/etc/ssh/initrd_ssh_host_ed25519_key" = "/etc/ssh/initrd_ssh_host_ed25519_key";
      };
    };
    kernel.sysctl = {
      "net.ipv6.conf.all.forwarding" = 1;
    };
  };

  # Make the mdadm conf available in stage2.
  environment.etc."mdadm.conf".text = mdadmConf;
  # The RAIDs are assembled in stage1, so we need to make the config available there too.
  boot.swraid.mdadmConf = mdadmConf;

  # Better for the SSD.
  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];

  environment = {
    interactiveShellInit = builtins.readFile ./bashrc;
    # Unset NixOS default shell aliases.
    shellAliases = {
      l = null;
      ls = null;
      ll = null;
    };
    variables = {
      EDITOR = "nvim";
      LC_COLLATE = "C"; # Lets special characters sort last; doesn't ignore them.
    };
    systemPackages = with pkgs; [
      curl
      git
      jq
      presage
      neovim
      pinentry-curses
      smartmontools
      vim
      wget
    ];
  };

  users = {
    users = {
      cron = {
        isSystemUser = true;
        uid = 1001;
        group = "cron";
      };
      blissful = {
        createHome = true;
        home = "/home/blissful";
        uid = 1000;
        shell = pkgs.fish;
        isNormalUser = true;
        extraGroups = [ "wheel" "docker" "nomad" "otel" ];
      };
    };
    groups = {
      cron = {
        gid = 1001;
      };
      presage = {
        gid = 2001;
        members = [ "blissful" "cron" "root" ];
      };
    };
  };

  virtualisation.docker.enable = true;
  services.tailscale.enable = true;
  programs.fish.enable = true;
}
