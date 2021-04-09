{ pkgs, ... }:

{
  imports = [
    ./keybase
    ./kitty
    ./signal
  ];

  home.packages = with pkgs; [
    discord
    firefox
    gnome3.evince
    gnome3.gedit
    mpv
    slack
    spotify
    tdesktop
    ungoogled-chromium
    zotero
  ];
}
