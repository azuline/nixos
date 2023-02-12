{ config, pkgs, ... }:

{
  system.stateVersion = "21.11";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  imports = [ ./hardware-configuration.nix ];

  time.timeZone = "UTC";
  i18n.defaultLocale = "en_US.UTF-8";

  networking = {
    hostName = "zen";
    useDHCP = false;
    interfaces.eno1.ipv4.addresses = [{ address = "147.135.1.125"; prefixLength = 24; }];
    defaultGateway = "147.135.1.254";
    nameservers = [ "1.1.1.1" ];
    firewall.allowedTCPPorts = [ 22 2222 ];
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
        # postCommands = ''
        #   echo 'cryptsetup-askpass' >> /root/.profile
        # '';
      };
      luks = {
        forceLuksSupportInInitrd = true;
        devices = {
          enc-pv = {
            device = "/dev/disk/by-uuid/de8653dc-4ad0-486f-a776-f04dc16273e7";
            preLVM = true;
            allowDiscards = true;
          };
        };
      };
      secrets = {
        "/etc/ssh/initrd_ssh_host_ed25519_key" = "/etc/ssh/initrd_ssh_host_ed25519_key";
      };
    };
  };

  # Better for the SSD.
  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];

  # https://gist.github.com/daymien/6e365de58ab37b54a96e8a6a41a79e6c#file-hetzner-dedicated-wipe-and-install-nixos-luks-raid-lvm-sh-L290
  environment.etc."mdadm.conf".text = "HOMEHOST <ignore>";
  # The RAIDs are assembled in stage1, so we need to make the config available there.
  boot.initrd.services.swraid.mdadmConf = config.environment.etc."mdadm.conf".text;

  environment = {
    interactiveShellInit = builtins.readFile ./bashrc;
    variables = {
      EDITOR = "nvim";
    };
    systemPackages = with pkgs; [
      curl
      jq
      neovim
      networkmanagerapplet
      powertop
      vim
      wget
      wireguard-tools
    ];
  };

  services.openssh = {
    enable = true;
    passwordAuthentication = false;
    permitRootLogin = "no";
  };

  users.users = {
    blissful = {
      createHome = true;
      home = "/home/blissful";
      uid = 1000;
      shell = pkgs.fish;
      isNormalUser = true;
      extraGroups = [ "wheel" "docker" ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK7+XlAgpi6eSC0GjgUq1bMOtGOzrOODBTkID8LuuZAL splendor"
      ];
    };
  };

  virtualisation.docker.enable = true;
}
