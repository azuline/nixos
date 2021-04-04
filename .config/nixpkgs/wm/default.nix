{ pkgs, ... }:

{
  imports = [
    ./dunst
    ./polybar
  ];

  home.packages = with pkgs; [
    picom
  ];
}
