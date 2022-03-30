{ config, pkgs, ... }:

let
  modules = import ../pkgs;
in
{
  programs.home-manager.enable = true;

  nixpkgs.overlays = [
    (import ../overlays/nixGLNvidia)
    (self: super: {
      screen = "desktop";
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
    themeModule
  ];

  home.packages = with pkgs; [
    # For the Logitech mouse.
    # solaar
  ];
}
