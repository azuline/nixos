{ pkgs, ... }:

{
  services = {
    xserver = {
      enable = true;
      desktopManager.xterm.enable = false;
      windowManager.i3 = {
        enable = true;
        package = pkgs.i3-gaps;
      };
      # screenSection = ''
      #   Option "metamodes" "DP-0: 3840x2160 +0+0 { ForceFullCompositionPipeline = On }, HDMI-0: 3840x2160 +3840+0 { ForceFullCompositionPipeline = On }"
      # '';
      screenSection = ''
        Option "metamodes" "HDMI-0: 3840x2160 +0+0 { ForceFullCompositionPipeline = On }"
      '';
      videoDrivers = [ "nvidia" ];
      xkb = {
        layout = "us";
        options = "altwin:swap_lalt_lwin,caps";
      };
    };
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
    enable32Bit = true;
  };
  hardware.nvidia = {
    modesetting.enable = true;
    nvidiaSettings = true;
    # The open source drivers don't work with the 1080Ti.
    open = false;
  };

  i18n.inputMethod = {
    enable = true;
    type = "ibus";
    ibus.engines = with pkgs.ibus-engines; [ table table-others libpinyin anthy ];
  };
  environment = {
    systemPackages = with pkgs; [
      ibus
      ibus-engines.libpinyin
    ];
    sessionVariables = {
      GTK_IM_MODULE = "ibus";
      QT_IM_MODULE = "ibus";
      XMODIFIERS = "@im=ibus";
      # Make ibus work with Kitty.
      GLFW_IM_MODULE = "ibus";
    };
  };

  fonts.fontconfig.defaultFonts = {
    serif = [ "EB Garamond" "Noto Serif CJK SC" "Noto Serif CJK JP" "Noto Serif CJK KR" "Noto Serif CJK TC" "Noto Serif CJK HK" ];
    sansSerif = [ "Roboto" "Noto Sans CJK SC" "Noto Sans CJK JP" "Noto Sans CJK KR" "Noto Sans CJK TC" "Noto Sans CJK HK" ];
    monospace = [ "Source Code Pro" ];
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

  services.samba = {
    enable = true;
    settings = {
      global = {
        # Browsing/Identification
        workgroup = "WORKGROUP";
        # Networking
        "bind interfaces only" = true;
        interfaces = [ "lo" "virbr0" "192.168.0.0/16" ];
        # Debugging/Accounting
        "log file" = "/var/log/samba/log.%m";
        "max log size" = 1000;
        logging = "file";
        "panic action" = "/usr/share/samba/panic-action %d";
        # Authentication
        "server role" = "standalone server";
        "obey pam restrictions" = true;
      };
      downloads = {
        # Downloads share configuration
        comment = "downloads dir";
        path = "/home/blissful/downloads";
        "guest ok" = "no";
        browseable = "yes";
        "read only" = "no";
        "valid users" = [ "blissful" ];
      };
      winshare = {
        # General share configuration
        comment = "general share";
        path = "/home/blissful/winshare";
        "guest ok" = "no";
        browseable = "yes";
        "read only" = "no";
        "valid users" = [ "blissful" ];
      };
      elements = {
        # Elements drive configuration
        comment = "elements drive";
        path = "/mnt/elements";
        "guest ok" = "no";
        browseable = "yes";
        "read only" = "yes";
        "valid users" = [ "blissful" ];
      };
    };
  };
}
