{ pkgs, ... }:

{
  home.packages = [ pkgs.picom ];
  xdg.configFile."picom/picom.conf".source = ./picom.conf;
}
