{ config, lib, pkgs, ... }:

let
  renew-certs = pkgs.writeShellScriptBin "renew-certs" ''
    ${pkgs.certbot}/bin/certbot certonly --manual --preferred-challenges=dns --agree-tos -d sunsetglow.net -d *.sunsetglow.net
    echo "Move the certs to /data/certs; automate this some day."
  '';
in
{
  system.stateVersion = "21.11";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.max-jobs = 8;

  imports = [
    ./hardware-configuration.nix
    ./services.nix
  ];

  time.timeZone = "UTC";
  i18n.defaultLocale = "en_US.UTF-8";

  networking = {
    hostName = "zen";
    useDHCP = false;
    interfaces.eno1.ipv4.addresses = [{ address = "147.135.1.125"; prefixLength = 24; }];
    defaultGateway = "147.135.1.254";
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
        version = 2;
        enableCryptodisk = true;
        device = "nodev";
      };
      supportsInitrdSecrets = true;
    };
    kernelParams = [ "ip=147.135.1.125::147.135.1.254:255.255.255.0:zen:eno1:off:1.1.1.1:" ];
    initrd = {
      kernelModules = [ "cryptd" "aesni_intel" "igb" ];
      network = {
        enable = true;
        ssh = {
          enable = true;
          port = 2222; # ssh port during boot for luks decryption; it will have a different host key from post-boot ssh
          authorizedKeys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK7+XlAgpi6eSC0GjgUq1bMOtGOzrOODBTkID8LuuZAL splendor" ];
          hostKeys = [ "/etc/ssh/initrd_ssh_host_ed25519_key" ];
        };
        # Set the shell profile to meet SSH connections with a decryption
        # prompt that writes to /tmp/continue if successful.
        # https://mth.st/blog/nixos-initrd-ssh/
        postCommands = ''
          echo 'cryptsetup open /dev/md/0 enc-pv && echo 'done' > /tmp/continue' >> /root/.profile
          echo 'starting sshd...'
        '';
      };
      # Block the boot process until /tmp/continue is written to
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
  };

  # Better for the SSD.
  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];

  environment.etc."mdadm.conf".text = ''
    HOMEHOST zen
    ARRAY /dev/md/0 level=raid1 num-devices=2 metadata=1.2 name=zen:md0 UUID=06d936cd:a777dfc1:6d15ed88:ddc88fa2
       devices=/dev/nvme0n1p3,/dev/nvme1n1p3
    ARRAY /dev/md/boot level=raid1 num-devices=2 metadata=1.0 name=zen:boot UUID=379a1967:098723b9:ae195d76:01d271c7
       devices=/dev/nvme0n1p2,/dev/nvme1n1p2
  '';
  # The RAIDs are assembled in stage1, so we need to make the config available there.
  boot.initrd.services.swraid.mdadmConf = config.environment.etc."mdadm.conf".text;

  environment = {
    interactiveShellInit = builtins.readFile ./bashrc;
    variables = {
      EDITOR = "nvim";
    };
    systemPackages = with pkgs; [
      certbot
      curl
      git
      jq
      neovim
      networkmanagerapplet
      powertop
      presage
      renew-certs
      smartmontools
      vim
      wget
      wireguard-tools
    ];
  };

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
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
        extraGroups = [ "wheel" "docker" "nomad" ];
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK7+XlAgpi6eSC0GjgUq1bMOtGOzrOODBTkID8LuuZAL splendor"
        ];
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
}
