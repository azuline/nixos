{ config, pkgs, ... }:

{
  programs.home-manager.enable = true;

  home.username = "blissful";
  home.homeDirectory = "/home/blissful";
  home.stateVersion = "21.05";

  imports = [
    ./apps
    ./fonts
    ./wm
    ./dev
  ];
}
