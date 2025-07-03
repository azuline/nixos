{ specialArgs, ... }:

let
  configBase = builtins.readFile ./config;
  config = (
    if specialArgs.sys.host == "splendor" then configBase + ''
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
    '' else if specialArgs.sys.host == "haiqin" && specialArgs.sys.monitor != null then configBase + ''
      # Font
      font pango: roboto 11

      # Gaps
      gaps inner 8
      gaps outer 2

      # Configure workspace monitor split.
      workspace 1 output eDP-1
      workspace 2 output eDP-1
      workspace 3 output eDP-1
      workspace 4 output eDP-1
      workspace 5 output eDP-1
      workspace 6 output ${specialArgs.sys.monitor}
      workspace 7 output ${specialArgs.sys.monitor}
      workspace 8 output ${specialArgs.sys.monitor}
      workspace 9 output ${specialArgs.sys.monitor}
      workspace 10 output ${specialArgs.sys.monitor}
    '' else if specialArgs.sys.host == "haiqin" then configBase + ''
      # Font
      font pango: roboto 11

      # Gaps
      gaps inner 4
      gaps outer 1
    '' else if specialArgs.sys.host == "neptune" then configBase + ''
      # Font
      font pango: roboto 11

      # Gaps
      gaps inner 1
      gaps outer 1
    '' else throw "Unsupported host in i3."
  );
in
{
  xsession.enable = true;
  xdg.configFile."i3/config".text = config;
}
