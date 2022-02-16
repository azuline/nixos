{ config, pkgs, ... }:

{
  imports = [
    ../pkgs/dunst
    ../pkgs/rofi
    ../pkgs/sway
    ../pkgs/swaylock
    ../pkgs/waybar
  ];

  home.packages = with pkgs; [
    swayidle
    # Change the name of a workspace based on its contents.
    swaywsr
  ];
}
