{ pkgs, ... }:

{
  xdg.configFile."user-dirs.dirs".source = ./user-dirs.dirs;
  home.file.".inputrc".source = ./inputrc;
  home.file.".xsessionrc".source = ./profile;
}
