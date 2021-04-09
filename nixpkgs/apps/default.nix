{ pkgs, ... }:

{
  imports = [
    ./keybase
    ./kitty
    ./mpv
    ./signal
  ];

  home.packages = with pkgs; [
    discord
    firefox
    gnome3.evince
    gnome3.gedit
    slack
    spotify
    tdesktop
    ungoogled-chromium
    zotero
  ];
}
