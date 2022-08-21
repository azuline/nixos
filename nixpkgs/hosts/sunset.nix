{ config, pkgs, ... }:

let
  modules = import ../pkgs;
in
{
  programs.home-manager.enable = true;
  nixpkgs.config.allowUnfree = true;

  home.username = "regalia";
  home.homeDirectory = "/home/regalia";
  home.stateVersion = "21.05";

  imports = with modules; [
    cliModule
    devModule
  ];
}
