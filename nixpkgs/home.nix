{ config, pkgs, ... }:

{
  programs.home-manager.enable = true;

  home.username = "blissful";
  home.homeDirectory = "/home/blissful";
  home.stateVersion = "21.05";

  imports = [
    ./sections/cli.nix
    ./sections/gui.nix
    ./sections/scripts.nix
    ./sections/dev.nix
    ./sections/env.nix
    ./sections/fonts.nix
    ./sections/wm.nix
  ];
}
