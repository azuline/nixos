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
    discord
    gnome3.gedit
    maim
    slack
    spotify
    tdesktop
    vscode
    zotero
    ungoogled-chromium
  ];
}
