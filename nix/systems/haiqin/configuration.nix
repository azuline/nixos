{ config, pkgs, ... }:

{
  system.stateVersion = "22.11";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  imports = [ ./hardware-configuration.nix ];

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    initrd.luks.devices = {
      root = {
        device = "/dev/nvme0n1p2";
        preLVM = true;
      };
    };
  };

  networking.hostName = "haiqin";
  networking.networkmanager.enable = true;

  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "ter-i32b";
    packages = with pkgs; [ terminus_font ];
    # Load the larger console font earlier in the boot process.
    earlySetup = true;
    # keyMap = "us";
    useXkbConfig = true; # use xkbOptions in tty.
  };

  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;

  # Gnome program configuration.
  programs.dconf.enable = true;

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
    # Option "TearFree" "true"
    layout = "us";
    xkbOptions = "altwin:swap_lalt_lwin,caps:escape_shifted_capslock";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.blissful = {
    createHome = true;
    home = "/home/blissful";
    uid = 1000;
    shell = pkgs.fish;
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "audio" "disk" "networkmanager" ];
  };

  environment.variables.EDITOR = "nvim";
  environment.systemPackages = with pkgs; [
    neovim
    vim
    wget
    curl
    jq
    networkmanagerapplet
    wireguard-tools
  ];
}
