{ pkgs, ... }:

{
  xdg.configFile."sway/config".source = ./config;
  home.file.".profile".source = ./sway-profile;
}
