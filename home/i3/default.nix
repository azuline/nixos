{ specialArgs, ... }:

let
  configBase = builtins.readFile ./config;
  config = (
    if specialArgs.sys.host == "splendor" then configBase + ''
      # Font
      font pango: roboto 11

      # Gaps
      gaps inner 16
      gaps outer 4

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
    '' else if specialArgs.sys.host == "haiqin" then configBase + ''
      # Font
      font pango: roboto 16

      # Gaps
      gaps inner 8
      gaps outer 2
    '' else throw "Invalid host in i3."
  );
in
{
  xsession.enable = true;
  xdg.configFile."i3/config".text = config;
}
