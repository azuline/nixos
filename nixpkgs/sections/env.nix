{ pkgs, ... }:

{
  xdg.configFile."user-dirs.dirs".source = ../scripts/user-dirs.dirs;
  xdg.configFile."direnv/direnv.toml".source = ../scripts/direnv.toml;
  home.file.".inputrc".source = ../scripts/inputrc;
  home.file.".xsessionrc".source = ../scripts/profile;
}
