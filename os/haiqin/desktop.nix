{ pkgs, ... }:

{
  services = {
    xserver = {
      enable = true;
      desktopManager.xterm.enable = false;
      dpi = 172;
      windowManager.i3 = {
        enable = true;
        package = pkgs.i3-gaps;
      };
      videoDrivers = [ "modesetting" ];
      deviceSection = ''
        Option "DRI" "3"
      '';
      # monitorSection = ''
      #   Section "Monitor"
      #     Identifier "LG UltraFine 5K"
      #     Modeline "5120x2880_60.00" 1188.00  5120 5376 5920 6720  2880 2883 2893 2944 -hsync +vsync
      #     Option "PreferredMode" "5120x2880_60.00"
      #   EndSection
      # '';
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

  hardware.graphics = {
    enable = true;
    extraPackages = [ pkgs.mesa.drivers ];
  };

  i18n.inputMethod = {
    enabled = "ibus";
    ibus.engines = with pkgs.ibus-engines; [ anthy ];
  };
  environment.variables = {
    # Make ibus work with Kitty.
    GLFW_IM_MODULE = "ibus";
  };

  qt = {
    enable = true;
    platformTheme = "gtk2";
    style = "gtk2";
  };

  fonts.fontconfig.defaultFonts = {
    serif = [ "EB Garamond" "Noto Serif CJK SC" "Noto Serif CJK JP" "Noto Serif CJK KR" "Noto Serif CJK TC" "Noto Serif CJK HK" ];
    sansSerif = [ "Roboto" "Noto Sans CJK SC" "Noto Sans CJK JP" "Noto Sans CJK KR" "Noto Sans CJK TC" "Noto Sans CJK HK" ];
    monospace = [ "Source Code Pro" ];
  };

  hardware.bluetooth.enable = true;
  sound.enable = true;

  services.mullvad-vpn.enable = true;
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
