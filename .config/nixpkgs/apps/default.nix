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
    gnome3.gedit
    mpv
    slack
    spotify
    tdesktop
    ungoogled-chromium
    zotero
  ];
}
