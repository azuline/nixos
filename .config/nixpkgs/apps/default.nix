{ pkgs, ... }:

{
  imports = [
    ./alacritty
    ./keybase
    ./signal
  ];

  home.packages = with pkgs; [
    discord
    firefox
    mpv
    slack
    spotify
    tdesktop
    zotero
  ];
}
