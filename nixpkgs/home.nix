{ config, pkgs, ... }:

{
  programs.home-manager.enable = true;

  nixpkgs.overlays = [
    (import ./overlays/nixGL.nix)
  ];

  home.username = "blissful";
  home.homeDirectory = "/home/blissful";
  home.stateVersion = "21.05";

  imports = [
    ./sections/cli.nix
    ./sections/dev.nix
    ./sections/env.nix
    ./sections/gui.nix
    ./sections/scripts.nix
    ./sections/theme.nix
    ./sections/wm.nix
  ];
}
