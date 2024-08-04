{ pkgs, specialArgs, ... }:


let
  "glyph" = {
    gleft = "%{T3}%{T-}    ";
    gright = "    %{T3}%{T-}";
  };
  colors = {
    background = "#d9090910";
    background-alt = "#bfc7d5";
    foreground = "#eeffff";
    foreground-alt = "#3e3e3e";
    primary = "#376181";
    secondary = "#8eace3";
    alert = "#ff5370";
  };
  shades = {
    shade1 = "#182130";
    shade2 = "#213148";
    shade3 = "#213e68";
    shade4 = "#265476";
  };
in
{
  # The tray service doesn't already exist; need to define it.
  systemd.user.targets.tray = {
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
    Unit = {
      Description = "Home Manager System Tray";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
  };

  services.polybar = {
    enable = true;
    package = pkgs.polybarFull;
    script = (
      if specialArgs.sys.host == "splendor" then
        ''
          # Only start if i3 socketpath succeeds.
          ${pkgs.i3-gaps}/bin/i3 --get-socketpath && polybar splendor-left &
          ${pkgs.i3-gaps}/bin/i3 --get-socketpath && polybar splendor-right &
        ''
      else if specialArgs.sys.host == "haiqin" then
        ''
          # Only start if i3 socketpath succeeds.
          ${pkgs.i3-gaps}/bin/i3 --get-socketpath && polybar haiqin &
        '' + (if specialArgs.sys.monitor then ''${pkgs.i3-gaps}/bin/i3 --get-socketpath && polybar monitor &'' else "")
      else if specialArgs.sys.host == "neptune" then
        ''
          # Only start if i3 socketpath succeeds.
          ${pkgs.i3-gaps}/bin/i3 --get-socketpath && polybar neptune &
        '' + (if specialArgs.sys.monitor then ''${pkgs.i3-gaps}/bin/i3 --get-socketpath && polybar monitor &'' else "")
      else throw "Unsupported host for polybar."
    );
    config = {
      "bar/base" = {
        width = "100%";
        height = "48";
        bottom = "true";
        radius = "0";
        fixed-center = "true";
        background = "#00000000";
        foreground = "${colors.foreground}";
        line-size = "2";
        font-0 = "roboto:pixelsize=17;4";
        font-1 = "Font Awesome 5 Free:style=Solid:size=14;3";
        font-2 = "Iosevka:style=Medium:size=30;8";
        font-3 = "Noto Sans VJK SC:style=Regular:size=17;4";
        font-4 = "Noto Sans CJK JP:style=Regular:size=17;4";
        font-5 = "Noto Sans CJK KR:style=Regular:size=17;4";
        font-6 = "Noto Sans CJK TC:style=Regular:size=17;4";
        font-7 = "Noto Sans CJK HK:style=Regular:size=17;4";
        modules-center = "";
        wm-restack = "i3";
        cursor-click = "pointer";
        cursor-scroll = "ns-resize";
      };
      "bar/splendor-left" = {
        "inherit" = "bar/base";
        monitor = "DP-0";
        tray-position = "right";
        tray-padding = "1";
        tray-background = shades.shade1;
        modules-left = "pad1 date pad1 left1 cpu gpu pad2 left2 memory pad3 left3 now-playing pad4 left4";
        modules-right = "right4 pad4 i3 right3 pad3 pulseaudio right2 pad2 vpn right1";
      };
      "bar/splendor-right" = {
        "inherit" = "bar/base";
        monitor = "HDMI-0";
        tray-position = "none";
        modules-left = "pad1 date pad1 left1 cpu gpu pad2 left2 memory pad3 left3 now-playing pad4 left4";
        modules-right = "right4 pad4 i3 right3 pad3 pulseaudio right2 pad2 vpn pad2";
      };
      "bar/haiqin" = {
        "inherit" = "bar/base";
        monitor = "eDP-1";
        height = "64";
        font-0 = "roboto:pixelsize=22;4";
        font-1 = "Font Awesome 5 Free:style=Solid:size=18;3";
        font-2 = "Iosevka:style=Medium:size=39;9";
        font-3 = "Noto Sans VJK SC:style=Regular:size=22;4";
        font-4 = "Noto Sans CJK JP:style=Regular:size=22;4";
        font-5 = "Noto Sans CJK KR:style=Regular:size=22;4";
        font-6 = "Noto Sans CJK TC:style=Regular:size=22;4";
        font-7 = "Noto Sans CJK HK:style=Regular:size=22;4";
        tray-position = "right";
        tray-padding = "1";
        tray-background = shades.shade1;
        tray-maxsize = "32";
        modules-left = "pad1 date pad1 left1 cpu pad2 left2 memory pad3 battery pad3 left3 now-playing pad4 left4";
        modules-right = "right4 pad4 i3 right3 pad3 pulseaudio pad3 brightness right2 pad2 vpn right1";
      };
      "bar/monitor" = {
        "inherit" = "bar/base";
        monitor = "HDMI-1";
        # tray-position = "right";
        # tray-padding = "1";
        # tray-background = shades.shade1;
        modules-left = "pad1 date pad1 left1 cpu pad2 left2 memory pad3 battery pad3 left3 now-playing pad4 left4";
        modules-right = "right4 pad4 i3 right3 pad3 pulseaudio pad3 brightness right2 pad2 vpn right1";
      };
      "bar/neptune" = {
        "inherit" = "bar/base";
        height = "48";
        font-0 = "roboto:pixelsize=17;4";
        font-1 = "Font Awesome 5 Free:style=Solid:size=14;3";
        font-2 = "Iosevka:style=Medium:size=30;8";
        font-3 = "Noto Sans VJK SC:style=Regular:size=17;4";
        font-4 = "Noto Sans CJK JP:style=Regular:size=17;4";
        font-5 = "Noto Sans CJK KR:style=Regular:size=17;4";
        font-6 = "Noto Sans CJK TC:style=Regular:size=17;4";
        font-7 = "Noto Sans CJK HK:style=Regular:size=17;4";
        tray-position = "right";
        tray-padding = "1";
        tray-background = shades.shade1;
        tray-maxsize = "24";
        modules-left = "pad1 date pad1 left1 cpu pad2 left2 memory pad3 battery pad3 left3 now-playing pad4 left4";
        modules-right = "right4 pad4 i3 right3 pad3 pulseaudio pad3 brightness right2 pad2 vpn right1";
      };
      "module/i3" = {
        type = "internal/i3";
        format = "<label-state> <label-mode>";
        index-sort = "true";
        wrapping-scroll = "false";
        label-mode-padding = "2";
        label-mode-foreground = "#000";
        label-mode-background = shades.shade4;
        # Active workspace on focused monitor
        label-focused = "%name%";
        label-focused-foreground = "#fff";
        label-focused-background = shades.shade4;
        label-focused-padding = "2";
        # Inactive workspace on any monitor
        label-unfocused = "%name%";
        label-unfocused-foreground = "#c6c6c6";
        label-unfocused-background = shades.shade4;
        label-unfocused-padding = "2";
        # Active workspace on unfocused monitor
        label-visible = "%name%";
        label-visible-foreground = "#c6c6c6";
        label-visible-background = shades.shade4;
        label-visible-padding = "2";
        # Workspace with urgency hint set
        label-urgent = "%name%";
        label-urgent-foreground = "#fff";
        label-urgent-background = colors.alert;
        label-urgent-padding = 2;
      };
      "module/cpu" = {
        type = "custom/script";
        exec = "~/.nix-profile/bin/bar-loadavg";
        label = "   %output%";
        interval = "2";
        format-background = shades.shade2;
      };
      "module/gpu" = {
        type = "custom/script";
        exec = "~/.nix-profile/bin/bar-gpu";
        label = "   ·   %output%";
        interval = "2";
        format-background = shades.shade2;
      };
      "module/vpn" = {
        type = "custom/script";
        exec = "~/.nix-profile/bin/bar-vpn";
        label = "   %output%";
        interval = "15";
        format-background = shades.shade2;
      };
      "module/memory" = {
        type = "internal/memory";
        interval = "2";
        format-prefix = "   ";
        label = "%gb_used:02%";
        format-background = shades.shade3;
      };
      "module/date" = {
        type = "internal/date";
        interval = "1";
        format-background = shades.shade1;
        date = "   %A :: %B %d :: %H:%M:%S";
      };
      "module/battery" = {
        type = "internal/battery";
        battery = "BAT0";
        format-prefix = "    ";
        # Full battery
        format-full = "<label-full>";
        format-full-background = shades.shade3;
        label-full = "   100%";
        label-full-foreground = colors.foreground;
        # Charging battery
        format-charging = "<label-charging>";
        format-charging-background = shades.shade3;
        label-charging = "   %percentage%%";
        label-charging-foreground = colors.foreground;
        # Discharging battery
        format-discharging = "<label-discharging>";
        format-discharging-background = shades.shade3;
        label-discharging = "   %percentage%%";
        label-discharging-foreground = colors.foreground;
      };
      "module/pulseaudio" = {
        type = "internal/pulseaudio";
        format-volume = "<label-volume>";
        format-volume-background = shades.shade3;
        label-volume = "   %percentage%%";
        label-volume-foreground = colors.foreground;
        format-muted-background = shades.shade3;
        label-muted = "   muted ";
        label-muted-foreground = "#666";
      };
      "module/brightness" = {
        type = "internal/backlight";
        card = "intel_backlight";
        format = "<label>";
        format-background = shades.shade3;
        label = "   %percentage%%";
        label-foreground = colors.foreground;
      };
      "module/title" = {
        type = "internal/xwindow";
        format-background = shades.shade4;
        label = "   %title%";
        label-maxlen = "50";
        label-empty = " Desktop ";
        label-empty-foreground = colors.foreground;
      };
      "module/now-playing" = {
        type = "custom/script";
        exec = "~/.nix-profile/bin/bar-now-playing";
        label = "   %output%";
        interval = "1";
        format-background = shades.shade4;
      };
      "global/wm" = {
        margin-top = "0";
        margin-bottom = "0";
      };
      # Cool arrows.
      "module/pad1" = {
        type = "custom/text";
        content-background = shades.shade1;
        content-foreground = shades.shade1;
        content = "    ";
      };
      "module/pad2" = {
        type = "custom/text";
        content-background = shades.shade2;
        content-foreground = shades.shade2;
        content = "    ";
      };
      "module/pad3" = {
        type = "custom/text";
        content-background = shades.shade3;
        content-foreground = shades.shade3;
        content = "    ";
      };
      "module/pad4" = {
        type = "custom/text";
        content-background = shades.shade4;
        content-foreground = shades.shade4;
        content = "    ";
      };
      # ==================================
      "module/left1" = {
        type = "custom/text";
        content-background = shades.shade2;
        content-foreground = shades.shade1;
        content = glyph.gleft;
      };
      "module/left2" = {
        type = "custom/text";
        content-background = shades.shade3;
        content-foreground = shades.shade2;
        content = glyph.gleft;
      };
      "module/left3" = {
        type = "custom/text";
        content-background = shades.shade4;
        content-foreground = shades.shade3;
        content = glyph.gleft;
      };
      "module/left4" = {
        type = "custom/text";
        content-background = "#00000000";
        content-foreground = shades.shade4;
        content = glyph.gleft;
      };
      # ==================================
      "module/right1" = {
        type = "custom/text";
        content-background = shades.shade2;
        content-foreground = shades.shade1;
        content = glyph.gright;
      };
      "module/right2" = {
        type = "custom/text";
        content-background = shades.shade3;
        content-foreground = shades.shade2;
        content = glyph.gright;
      };
      "module/right3" = {
        type = "custom/text";
        content-background = shades.shade4;
        content-foreground = shades.shade3;
        content = glyph.gright;
      };
      "module/right4" = {
        type = "custom/text";
        content-background = "#00000000";
        content-foreground = shades.shade4;
        content = glyph.gright;
      };
    };
  };
}
