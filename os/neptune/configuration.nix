{
  lib,
  pkgs,
  pin,
  ...
}:

{
  system.stateVersion = "22.11";
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.settings.max-jobs = 8;
  nixpkgs.config.allowUnfree = true;
  # Doesn't work in Flakes.
  programs.command-not-found.enable = false;

  imports = [
    ./hardware-configuration.nix
    ./desktop.nix
    ./torrents.nix
    ./services.nix
    ./zfs.nix
  ];

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    initrd.luks.devices.root = {
      device = "/dev/disk/by-partuuid/d64584d6-6d18-42fb-b7b1-16c2a241122e";
      preLVM = true;
    };
    # True by default; creates a warning when other parameters are unset. So we
    # disable it. See https://github.com/NixOS/nixpkgs/issues/254807.
    swraid.enable = false;
  };

  networking = {
    hostName = "neptune";
    hostId = "b5b16f96"; # head -c4 /dev/urandom | od -A none -t x4
    extraHosts = '''';
    # Static LAN IP so that we can port forward and deterministically bind to it and shit.
    useDHCP = false;
    interfaces.enp60s0u1.ipv4.addresses = [
      {
        address = "192.168.1.207";
        prefixLength = 24;
      }
    ];
    defaultGateway = "192.168.1.1";
    # Cos I love firewalling.
    firewall = {
      allowedTCPPorts = [
        22000 # syncthing
      ];
      # For tailscale https://github.com/tailscale/tailscale/issues/4432.
      checkReversePath = "loose";
      interfaces.enp60s0u1 = {
        allowedTCPPorts = [
          22 # ssh
          32400 # plex
          3005 # plex
          8324 # plex
          32469 # plex
        ];
        allowedUDPPorts = [
          1900 # plex
          5353 # plex
          32410 # plex
          32412 # plex
          32413 # plex
          32414 # plex
        ];
      };
      interfaces.tailscale0 = {
        allowedTCPPorts = [
          22 # ssh
          4646 # nomad
          8500 # consul
          9001 # thelounge
          12834 # transmission
        ];
      };
    };
  };
  # https://github.com/NixOS/nixpkgs/issues/195777#issuecomment-1324378856
  system.activationScripts.restart-udev = "${pkgs.systemd}/bin/systemctl restart systemd-udev-trigger.service";

  time.timeZone = "America/Los_Angeles";
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "ter-i32b";
    packages = with pkgs; [ terminus_font ];
    # Load the larger console font earlier in the boot process.
    earlySetup = true;
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
        extraGroups = [
          "wheel"
          "video"
          "audio"
          "disk"
          "networkmanager"
          "docker"
          "media"
        ];
      };
      plex = {
        createHome = false;
        uid = lib.mkForce 1001;
        isNormalUser = true;
      };
    };
    groups = {
      media.gid = 1001;
    };
  };

  services.plex = {
    enable = true;
    dataDir = "/data/plex";
    user = "plex";
    group = "media";
    # Manually exposed on the local network; public plex is security nightmware.
    openFirewall = false;
    extraPlugins = [
      (builtins.path {
        name = "Hama.bundle";
        path = pin.plex-hama;
      })
    ];
    extraScanners = [ pin.plex-ass ];
  };

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
      PASSWORD_STORE_DIR = "/home/blissful/.passwarbles";
    };
    systemPackages = with pkgs; [
      curl
      git
      glxinfo
      intel-gpu-tools
      jq
      mesa
      neovim
      networkmanagerapplet
      nftables
      pinentry-curses
      powertop
      smartmontools
      tomb
      vim
      wget
      wireguard-tools
    ];
  };

  virtualisation.docker.enable = true;
  services.tailscale.enable = true;
  services.openssh.enable = true;
  programs.fish.enable = true;

  services.tlp = {
    enable = true;
    settings = {
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      PLATFORM_PROFILE_ON_AC = "performance";
      CPU_BOOST_ON_AC = 1;
      CPU_HWP_DYN_BOOST_ON_AC = 1;

      # CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_performance";
      # PLATFORM_PROFILE_ON_BAT = "balanced";
      # CPU_BOOST_ON_BAT = 0;
      # CPU_HWP_DYN_BOOST_ON_BAT = 0;

      START_CHARGE_THRESH_BAT0 = 80;
      STOP_CHARGE_THRESH_BAT0 = 85;
    };
  };

  # Keeps on killing everything every five minutes due to ZFS and some weird
  # RAM spike. Everything runs fine with it off.
  systemd.oomd.enable = false;
}
