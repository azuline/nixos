{ config, pkgs, ... }:

let
  modules = import ../pkgs;
in
{
  programs.home-manager.enable = true;
  nixpkgs.config.allowUnfree = true;
  # Workaround for flakes https://github.com/nix-community/home-manager/issues/2942.
  nixpkgs.config.allowUnfreePredicate = (pkg: true);

  nixpkgs.overlays = [
    (import ../overlays/nixGLNvidia)
    (self: super: {
      screen = "desktop";
    })
  ];

  home = {
    username = "blissful";
    homeDirectory = "/home/blissful";
    stateVersion = "21.05";
  };

  imports = with modules; [
    cliModule
    devModule
    envModule
    guiModule
    i3Module
    themeModule
  ];
}
