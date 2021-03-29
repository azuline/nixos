{ pkgs, ... }:

let
  stable = import <stable> {};
in
{
  imports = [
    ./keybase
    ./signal
  ];

  home.packages = with pkgs; [
    firefox
    slack
    spotify
    tdesktop
    zotero

    # Overrides
    stable.discord
  ];
}
