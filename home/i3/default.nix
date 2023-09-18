{ specialArgs, ... }:

let
  configBase = builtins.readFile ./config;
  config = (
    if specialArgs.sys.host == "splendor" then configBase + ''
      gaps inner 16
      gaps outer 4
    '' else if specialArgs.sys.host == "haiqin" then configBase + ''
      gaps inner 8
      gaps outer 2
    '' else throw "Invalid host in i3."
  );
in
{
  xsession.enable = true;
  xdg.configFile."i3/config".text = config;
}
