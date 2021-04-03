{ pkgs, ... }:

let
  stable = import <stable> {};
in
{
  imports = [
    ./alacritty
    ./keybase
    ./signal
  ];

  home.packages = with pkgs; [
    firefox
    mpv
    slack
    spotify
    tdesktop
    zotero

    # Overrides
    stable.discord
  ];
}
