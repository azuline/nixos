{ pkgs, ... }:

{
  xdg.configFile."i3/config".source = ./config;
  home.file.".xsessionrc".source = ./xsessionrc;
}
