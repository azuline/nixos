{ config, pkgs, ... }:

let
  modules = import ../pkgs;
in
{
  programs.home-manager.enable = true;
  nixpkgs.config.allowUnfree = true;

  nixpkgs.overlays = [
    (self: super: {
      screen = "laptop";
    })
  ];

  home.username = "blissful";
  home.homeDirectory = "/home/blissful";
  home.stateVersion = "21.05";

  imports = with modules; [
    cliModule
    devModule
    envModule
    guiModule
    i3Module
    swayModule
    themeModule
  ];
}
