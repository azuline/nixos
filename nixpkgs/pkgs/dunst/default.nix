{ pkgs, ... }:

let
  # TODO: Make this work??
  # drv = if pkgs.screen == "desktop" then ./desktop.nix else ./laptop.nix;
  drv = ./desktop.nix;
in
{
  imports = [ drv ];
}
