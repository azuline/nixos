{ pkgs, specialArgs, ... }:

let
  config =
    if specialArgs.sys.host == "splendor" then
      builtins.readFile ./kitty.conf + ''
        font_size 15.0
        window_padding_width 8
      ''
    else if specialArgs.sys.host == "haiqin" then
      builtins.readFile ./kitty.conf + ''
        font_size 22.0
        window_padding_width 8
      ''
    else throw "Unsupported host in kitty.";
in
{
  programs.kitty.enable = true;
  xdg.configFile."kitty/kitty.conf".text = config;
}
