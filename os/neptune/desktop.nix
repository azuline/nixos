{ pkgs, ... }:

{
  services = {
    xserver = {
      enable = true;
      desktopManager.xterm.enable = false;
      dpi = 132;
      windowManager.i3 = {
        enable = true;
        package = pkgs.i3-gaps;
      };
      videoDrivers = [ "modesetting" ];
      deviceSection = ''
        Option "DRI" "3"
      '';
      xkb = {
        layout = "us";
        options = "altwin:swap_lalt_lwin,caps:escape_shifted_capslock";
      };
      displayManager.sessionCommands = ''
        ${pkgs.xorg.xinput}/bin/xinput --set-prop 'TPPS/2 Elan TrackPoint' 'Evdev Wheel Emulation' 1
        ${pkgs.xorg.xinput}/bin/xinput --set-prop 'TPPS/2 Elan TrackPoint' 'Evdev Wheel Emulation Button' 2
        ${pkgs.xorg.xinput}/bin/xinput --set-prop 'TPPS/2 Elan TrackPoint' 'Evdev Wheel Emulation Axes' 6 7 4 5
      '';
    };
    # Disable libinput because I don't want to use the touchpad.
    libinput.enable = false;
    displayManager = {
      defaultSession = "none+i3";
      # It's fine to enable autologin since we have disk encryption.
      autoLogin = {
        enable = true;
        user = "blissful";
      };
    };
  };

  # Always on; home server.
  systemd.sleep.extraConfig = ''
    AllowSuspend=no
    AllowHibernation=no
    AllowHybridSleep=no
    AllowSuspendThenHibernate=no
  '';

  hardware.graphics = {
    enable = true;
    extraPackages = [ pkgs.mesa.drivers ];
  };

  i18n.inputMethod = {
    enable = true;
    type = "ibus";
    ibus.engines = with pkgs.ibus-engines; [ anthy ];
  };
  environment.sessionVariables = {
    GTK_IM_MODULE = "ibus";
    QT_IM_MODULE = "ibus";
    XMODIFIERS = "@im=ibus";
    # Make ibus work with Kitty.
    GLFW_IM_MODULE = "ibus";
  };

  qt = {
    enable = true;
    platformTheme = "gtk2";
    style = "gtk2";
  };

  hardware.bluetooth.enable = true;

  services.gvfs.enable = true;
  services.gnome.gnome-keyring.enable = true;
  services.upower.enable = true;
  services.blueman.enable = true;
  services.printing.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  programs.dconf.enable = true;
  programs.seahorse.enable = true;
}
