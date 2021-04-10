{ pkgs, ... }:

{
  xdg.configFile."user-dirs.dirs".source = ../scripts/user-dirs.dirs;
  home.file.".inputrc".source = ../scripts/inputrc;
  home.file.".xsessionrc".source = ../scripts/profile;
}
