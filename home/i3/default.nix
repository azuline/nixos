{ specialArgs, ... }:

let
  configBase = builtins.readFile ./config;
  xsessionrcBase = builtins.readFile ./xsessionrc;
  config = (
    if specialArgs.sys.host == "splendor" then configBase + ''
      gaps inner 16
      gaps outer 4
    '' else if specialArgs.sys.host == "haiqin" then configBase + ''
      gaps inner 8
      gaps outer 2
    '' else throw "Invalid host in i3."
  );
  xsessionrc = (
    if specialArgs.sys.host == "splendor" then xsessionrcBase + ''
      xrandr --output HDMI-0 --right-of DP-0
      xrandr --output DP-0 --primary
    '' else if specialArgs.sys.host == "haiqin" then xsessionrcBase
    else throw "Invalid host in i3."
  );
in
{
  xdg.configFile."i3/config".text = config;
  home.file.".xsessionrc".text = xsessionrc;
}
