{ config, pkgs, ... }:

{
  programs.home-manager.enable = true;

  nixpkgs.overlays = [
    (import ../overlays/nixGL)
  ];

  home.username = "blissful";
  home.homeDirectory = "/home/blissful";
  home.stateVersion = "21.05";

  imports = [
    ../groups/cli.nix
    ../groups/dev.nix
    ../groups/env.nix
    ../groups/gui.nix
    ../groups/i3.nix
    ../groups/theme.nix
  ];
}
