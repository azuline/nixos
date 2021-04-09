{ config, pkgs, ... }:

{
  imports = [
    ./dunst
    ./i3
    ./picom
    ./polybar
    ./rofi
  ];
}
