{ pkgs, ... }:

{
  imports = [
    ../pkgs/keybase
    ../pkgs/kitty
    ../pkgs/mpv
    ../pkgs/signal
  ];

  home.packages = with pkgs; [
    discord
    firefox
    # gnome3.evince
    gnome3.gedit
    slack
    spotify
    tdesktop
    ungoogled-chromium
    zotero
    maim
  ];
}
