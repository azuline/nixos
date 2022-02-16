{ pkgs, ... }:

{
  xdg.configFile."sway/config".source = ./config;
}
