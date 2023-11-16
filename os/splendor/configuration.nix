{ config, pkgs, ... }:

{
  system.stateVersion = "22.11";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.max-jobs = 12;
  nixpkgs.config.allowUnfree = true;
  # Doesn't work in Flakes.
  programs.command-not-found.enable = false;

  imports = [
    ./hardware-configuration.nix
    ./torrents.nix
    ./desktop.nix
    ./vm.nix
  ];

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    initrd.luks.devices.root = {
      device = "/dev/disk/by-uuid/c1bc2705-939f-4dc4-b6ce-6527192463a9";
      preLVM = true;
    };
    # True by default; creates a warning when other parameters are unset. So we
    # disable it. See https://github.com/NixOS/nixpkgs/issues/254807.
    swraid.enable = false;
    kernelModules = [
      # == For qemu-kvm ==
      "vfio"
      "vfio_iommu_type1"
      "vfio_pci"
      "vhost-net"
    ];
    kernelParams = [
      # == For qemu-kvm ==
      "intel_iommu=on"
      "vfio-pci.ids=10de:2184,10de:1aeb,10de:1aec,10de:1aed"
      # 16GB with the default size of 2048kB size hugepages. For the virtual machine.
      "nr_hugepages=8600"
    ];
  };

  fileSystems = {
    "/mnt/elements" = {
      device = "/dev/disk/by-uuid/01822c0a-0963-47b4-8f3c-a9765ea53093";
      fsType = "ext4";
    };
    "/mnt/backup" = {
      device = "/dev/disk/by-uuid/09ca7108-e0de-4fc8-9cbf-86fee575bba3";
      fsType = "ext4";
    };
  };

  networking = {
    hostName = "splendor";
    networkmanager.enable = true;
    interfaces.wlp5s0.ipv4.addresses = [
      {
        address = "192.168.1.160";
        prefixLength = 24;
      }
    ];
    firewall = {
      allowedTCPPorts = [
        22000 # syncthing
      ];
      # For tailscale https://github.com/tailscale/tailscale/issues/4432.
      checkReversePath = "loose";
      interfaces.tailscale0 = {
        allowedTCPPorts = [
          22 # ssh
          19187 # atelier
        ];
      };
      # Virtual machine. Allow all ports.
      interfaces.virbr0 = {
        allowedTCPPortRanges = [{ from = 1; to = 65535; }];
        allowedUDPPortRanges = [{ from = 1; to = 65535; }];
      };
    };
  };

  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "ter-i32b";
    packages = with pkgs; [ terminus_font ];
    useXkbConfig = true;
  };

  users = {
    users = {
      blissful = {
        createHome = true;
        home = "/home/blissful";
        uid = 1000;
        shell = pkgs.fish;
        isNormalUser = true;
        extraGroups = [ "wheel" "video" "audio" "disk" "networkmanager" "docker" "media" "libvirtd" ];
      };
      # Controlled by transmission.nix.
      transmission = { };
    };
    groups = {
      media.gid = 1001;
    };
  };

  # Allow this command to use sudo without password. This allows us to avoid
  # asking for sudo throughout the backup script.
  security.sudo.configFile = ''
    blissful ALL=(ALL:ALL) NOPASSWD: ${pkgs.tomb}/bin/tomb
  '';

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
      XCURSOR_SIZE = "64";
      LC_COLLATE = "C"; # Lets special characters sort last; doesn't ignore them.
    };
    systemPackages = with pkgs; [
      borgbackup
      curl
      git
      jq
      neovim
      networkmanagerapplet
      dmidecode
      nftables
      pciutils
      pinentry-curses
      powertop
      lshw
      synergy
      restic
      smartmontools
      tomb
      vim
      wget
      wireguard-tools
    ];
  };

  virtualisation.docker.enable = true;
  programs.fish.enable = true;
  services.tailscale.enable = true;
}
