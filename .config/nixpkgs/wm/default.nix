{ pkgs, ... }:

{
  imports = [
    ./polybar
  ];

  home.packages = with pkgs; [
    dunst
    picom
  ];
}
