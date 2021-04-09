{ config, pkgs, ... }:

{
  imports = [
    ./dunst
    ./picom
    ./polybar
    ./rofi
  ];
}
