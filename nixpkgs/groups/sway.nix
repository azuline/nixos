{ config, pkgs, ... }:

let
  sway-clear-clipboard =
    pkgs.writeScriptBin "sway-clear-clipboard" (builtins.readFile ../scripts/sway-clear-clipboard.sh);
  sway-pass = pkgs.writeScriptBin "sway-pass" (builtins.readFile ../scripts/sway-pass.sh);
  sway-yy = pkgs.writeScriptBin "sway-yy" (builtins.readFile ../scripts/sway-yy.sh);
in
{
  imports = [
    ../pkgs/dunst
    ../pkgs/rofi
    ../pkgs/sway
    ../pkgs/swaylock
    ../pkgs/waybar
  ];

  home.file.".profile".source = ../configFiles/profile;

  home.packages = with pkgs; [
    swayidle
    # Change the name of a workspace based on its contents.
    swaywsr
    sway-clear-clipboard
    sway-pass
    sway-yy
  ];
}
