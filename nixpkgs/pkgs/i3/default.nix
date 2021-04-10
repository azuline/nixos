{ pkgs, ... }:

{
  xdg.configFile."i3/config".source = ./config;
}
