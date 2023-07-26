{ pkgs, ... }:

{
  # home.packages = [ pkgs.mpv ];  # GPU stuff
  xdg.configFile."mpv/mpv.conf".source = ./mpv.conf;
}
