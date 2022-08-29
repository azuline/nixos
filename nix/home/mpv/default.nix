{ pkgs, ... }:

{
  home.packages = [ pkgs.mpv ];
  xdg.configFile."mpv/mpv.conf".source = ./mpv.conf;
}
