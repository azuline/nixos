{ config, pkgs, ... }:

# Some packages are installed outside of Nix, just because I can't get them to work.
# - rofi (starting evolution via nix rofi spawned glibc issues)
# - evolution (i have a custom tray plugin and idk how to do it in nixos)
# - calibre (in nixos i just got errors firing it up)

# TODO:
# - Add `--use-tray-icon` to signal's *.desktop (add a sed into installPHase)?

let
  stable = import <stable> {};
in
{
  programs.home-manager.enable = true;

  home.username = "blissful";
  home.homeDirectory = "/home/blissful";
  home.stateVersion = "21.05";

  ### Nix Shit

  # Enables direnv
  # programs.direnv.enable = true;
  # programs.direnv.enableNixDirenvIntegration = true;

  ### Services

  services.keybase.enable = true;
  services.kbfs.enable = true;

  ### Packages

  programs.fish.enable = true;

  home.packages = with pkgs; [
    autossh
    jq
    keybase-gui
    polybarFull
    signal-desktop
    slack
    spotify
    tdesktop
    zoom
    zotero
    stable.discord
  ];
}
