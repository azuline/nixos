{ config, pkgs, ... }:

{
  programs.home-manager.enable = true;

  home.username = "blissful";
  home.homeDirectory = "/home/blissful";
  home.stateVersion = "21.05";

  imports = [
    ./sections/apps.nix
    ./sections/bin.nix
    ./sections/dev.nix
    ./sections/env.nix
    ./sections/fonts.nix
    ./sections/wm.nix
  ];
}
