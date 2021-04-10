{ config, pkgs, ... }:

{
  imports = [
    ../pkgs/dunst
    ../pkgs/i3
    ../pkgs/picom
    ../pkgs/polybar
    ../pkgs/rofi
  ];
}
