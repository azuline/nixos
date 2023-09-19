{ config, pkgs, ... }:

{
  system.stateVersion = "22.11";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.max-jobs = 8;
  nixpkgs.config.allowUnfree = true;

  imports = [ ./hardware-configuration.nix ];

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    initrd.luks.devices.root = {
      device = "/dev/nvme0n1p2";
      preLVM = true;
    };
    # True by default; creates a warning when other parameters are unset. So we
    # disable it. See https://github.com/NixOS/nixpkgs/issues/254807.
    swraid.enable = false;
  };

  networking = {
    hostName = "haiqin";
    networkmanager.enable = true;
    extraHosts = ''
    '';
    firewall = {
      allowedTCPPorts = [
        22000 # syncthing
      ];
      # For tailscale https://github.com/tailscale/tailscale/issues/4432.
      checkReversePath = "loose";
      interfaces.tailscale0 = {
        allowedTCPPorts = [
          22 # ssh
        ];
      };
    };
  };

  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";

  console = {
    font = "ter-i32b";
    packages = with pkgs; [ terminus_font ];
    # Load the larger console font earlier in the boot process.
    earlySetup = true;
    useXkbConfig = true;
  };

  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;
  hardware.opengl.extraPackages = [ pkgs.mesa.drivers ];

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    desktopManager.xterm.enable = false;
    displayManager = {
      defaultSession = "none+i3";
      # startx.enable = true;
      # It's fine to enable autologin since we have disk encryption.
      autoLogin = {
        enable = true;
        user = "blissful";
      };
      sessionCommands = ''
        ${pkgs.xorg.xinput}/bin/xinput --set-prop 'TPPS/2 Elan TrackPoint' 'Evdev Wheel Emulation' 1
        ${pkgs.xorg.xinput}/bin/xinput --set-prop 'TPPS/2 Elan TrackPoint' 'Evdev Wheel Emulation Button' 2
        ${pkgs.xorg.xinput}/bin/xinput --set-prop 'TPPS/2 Elan TrackPoint' 'Evdev Wheel Emulation Axes' 6 7 4 5
      '';
    };
    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
    };
    videoDrivers = [ "modesetting" ];
    deviceSection = ''
      Option "DRI" "3"
    '';
    layout = "us";
    xkbOptions = "altwin:swap_lalt_lwin,caps:escape_shifted_capslock";
    # Disable libinput because I don't want to use the touchpad.
    libinput.enable = false;
  };

  programs.dconf.enable = true;
  services.printing.enable = true;
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.package = pkgs.pulseaudioFull;

  users.users.blissful = {
    createHome = true;
    home = "/home/blissful";
    uid = 1000;
    shell = pkgs.fish;
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "audio" "disk" "networkmanager" "docker" ];
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
    };
    systemPackages = with pkgs; [
      curl
      jq
      mesa
      neovim
      intel-gpu-tools
      glxinfo
      networkmanagerapplet
      powertop
      vim
      wget
      nftables
      wireguard-tools
    ];
  };

  services.tlp = {
    enable = true;
    settings = {
      CPU_BOOST_ON_BAT = 0;
      CPU_SCALING_GOVERNOR_ON_BATTERY = "powersave";
      START_CHARGE_THRESH_BAT0 = 90;
      STOP_CHARGE_THRESH_BAT0 = 97;
      RUNTIME_PM_ON_BAT = "auto";
    };
  };

  qt = {
    enable = true;
    platformTheme = "gtk2";
    style = "gtk2";
  };

  virtualisation.docker.enable = true;
  services.gvfs.enable = true;
  services.gnome.gnome-keyring.enable = true;
  services.mullvad-vpn.enable = true;
  services.upower.enable = true;
  programs.seahorse.enable = true;
  services.tailscale.enable = true;
  programs.fish.enable = true;
  # Doesn't work in Flakes.
  programs.command-not-found.enable = false;
}
