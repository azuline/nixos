{ config, pkgs, ... }:

{
  system.stateVersion = "22.11";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.max-jobs = 12;

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
    hostName = "splendor";
    networkmanager.enable = true;
    extraHosts = ''
    '';
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
      '';
    };
    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
    };
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
    variables = {
      EDITOR = "nvim";
      XCURSOR_SIZE = "64";
    };
    systemPackages = with pkgs; [
      curl
      jq
      neovim
      networkmanagerapplet
      powertop
      vim
      wget
      nftables
      wireguard-tools
    ];
  };

  virtualisation.docker.enable = true;
  services.gnome.gnome-keyring.enable = true;
  services.mullvad-vpn.enable = true;
  services.upower.enable = true;
  programs.seahorse.enable = true;
  services.tailscale.enable = true;
  programs.fish.enable = true;
}
