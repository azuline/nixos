{ pkgs, ... }:

{
  imports = [
    ../pkgs/firefox
    ../pkgs/keybase
    ../pkgs/kitty
    ../pkgs/mpv
    ../pkgs/signal
  ];

  home.packages = with pkgs; [
    arandr
    discord
    feh
    gimp
    gnome3.gedit
    gnome3.nautilus
    maim
    slack
    spotify
    tdesktop
    transmission-qt
    ungoogled-chromium
    vscode
    zotero
  ];
}
