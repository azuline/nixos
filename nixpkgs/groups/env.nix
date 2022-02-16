{ pkgs, ... }:

{
  xdg.configFile."user-dirs.dirs".source = ../configFiles/user-dirs.dirs;
  xdg.configFile."direnv/direnv.toml".source = ../configFiles/direnv.toml;
  home.file.".inputrc".source = ../configFiles/inputrc;
  home.file.".xsessionrc".source = ../configFiles/profile;
}
