{ config, pkgs, ... }:

{
  imports = [
    ../pkgs/discord
    # Excluding this on neptune so XWayland can open links.
    ../pkgs/firefox
    ../pkgs/keybase
    ../pkgs/kitty
    ../pkgs/alacritty
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
    # Excluding this on neptune since it can't connect.
    slack
    spotify
    tdesktop
    ungoogled-chromium
    # Can't dl...
    xorg.xkill
    grim
    slurp
    # Excluding this because open PDF is broken.
    # zotero
    # Excluding this for proper QT theming.
    # transmission-qt
  ];
}
