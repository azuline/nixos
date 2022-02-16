{ pkgs, ... }:

{
  imports = [
    ../pkgs/discord
    ../pkgs/firefox
    ../pkgs/keybase
    ../pkgs/kitty
    ../pkgs/mpv
    ../pkgs/signal
  ];

  home.packages = with pkgs; [
    arandr
    feh
    gimp
    gnome3.gedit
    gnome3.nautilus
    maim
    slack
    spotify
    tdesktop
    ungoogled-chromium
    # Can't dl...
    xorg.xkill
    # Excluding this because open PDF is broken.
    # zotero
    # Excluding this for proper QT theming.
    # transmission-qt
  ];
}
