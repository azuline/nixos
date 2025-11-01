{ specialArgs, themeColors, ... }:

let
  # Generate color definitions from themeColors
  colorDefs = ''
    ### Colors
    # Background/Foreground/Cursor
    set $color_fg    ${themeColors.ui.foreground}
    set $color_bg    ${themeColors.ui.background}
    # Border
    set $color_br    ${themeColors.ui.border}
    # Black
    set $color0      ${themeColors.terminal.color0}
    set $color8      ${themeColors.terminal.color8}
    # Red
    set $color1      ${themeColors.terminal.color1}
    set $color9      ${themeColors.terminal.color9}
    # Green
    set $color2      ${themeColors.terminal.color2}
    set $color10     ${themeColors.terminal.color10}
    # Yellow
    set $color3      ${themeColors.terminal.color3}
    set $color11     ${themeColors.terminal.color11}
    # Blue
    set $color4      ${themeColors.terminal.color4}
    set $color12     ${themeColors.terminal.color12}
    # Magenta
    set $color5      ${themeColors.terminal.color5}
    set $color13     ${themeColors.terminal.color13}
    # Cyan
    set $color6      ${themeColors.terminal.color6}
    set $color14     ${themeColors.terminal.color14}
    # White
    set $color7      ${themeColors.terminal.color7}
    set $color15     ${themeColors.terminal.color15}

  '';

  configBase = colorDefs + builtins.readFile ./config;
  config = (
    if specialArgs.sys.host == "splendor" then
      configBase
      + ''
        # Font
        font pango: roboto 11

        # Gaps
        gaps inner 8
        gaps outer 2

        # Configure workspace monitor split.
        workspace 1 output DP-0
        workspace 2 output DP-0
        workspace 3 output DP-0
        workspace 4 output DP-0
        workspace 5 output DP-0
        workspace 6 output HDMI-0
        workspace 7 output HDMI-0
        workspace 8 output HDMI-0
        workspace 9 output HDMI-0
        workspace 10 output HDMI-0
      ''
    else if specialArgs.sys.host == "haiqin" && specialArgs.sys.monitor != null then
      configBase
      + ''
        # Font
        font pango: roboto 11

        # Gaps
        gaps inner 8
        gaps outer 2

        # Configure workspace monitor split.
        workspace 1 output ${specialArgs.sys.monitor}
        workspace 2 output ${specialArgs.sys.monitor}
        workspace 3 output ${specialArgs.sys.monitor}
        workspace 4 output ${specialArgs.sys.monitor}
        workspace 5 output ${specialArgs.sys.monitor}
        workspace 6 output DP-3
        workspace 7 output DP-3
        workspace 8 output DP-3
        workspace 9 output DP-3
        workspace 10 output eDP-1
      ''
    else if specialArgs.sys.host == "haiqin" then
      configBase
      + ''
        # Font
        font pango: roboto 11

        # Gaps
        gaps inner 4
        gaps outer 1
      ''
    else if specialArgs.sys.host == "neptune" then
      configBase
      + ''
        # Font
        font pango: roboto 11

        # Gaps
        gaps inner 1
        gaps outer 1
      ''
    else
      throw "Unsupported host in i3."
  );
in
{
  xsession.enable = true;
  xdg.configFile."i3/config".text = config;
}
