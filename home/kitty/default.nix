{ pkgs, specialArgs, ... }:

let
  config =
    if specialArgs.sys.host == "splendor" || specialArgs.sys.monitor != null then
      builtins.readFile ./kitty.conf
      + ''
        font_size 15.0
        window_padding_width 8
      ''
    else if specialArgs.sys.host == "sunrise" then
      builtins.readFile ./kitty.conf
      + ''
        font_size 14.0
        window_padding_width 8
      ''
    else if specialArgs.sys.host == "haiqin" then
      builtins.readFile ./kitty.conf
      + ''
        font_size 22.0
        window_padding_width 8
      ''
    else if specialArgs.sys.host == "neptune" then
      builtins.readFile ./kitty.conf
      + ''
        font_size 15.0
        window_padding_width 8
      ''
    else
      throw "Unsupported host in kitty.";
in
{
  programs.kitty.enable = true;
  xdg.configFile."kitty/kitty.conf".text = config;
}
