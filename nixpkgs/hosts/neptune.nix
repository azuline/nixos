{ config, pkgs, ... }:

let
  modules = import ../pkgs;
in
{
  programs.home-manager.enable = true;

  nixpkgs.overlays = [
    (import ../overlays/nixGLIntel)
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
    swayModule
    themeModule
  ];
}
