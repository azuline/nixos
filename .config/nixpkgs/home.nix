{ config, pkgs, ... }:

# Setup
# - Add the stable channel with `$ nix-channel --add https://nixos.org/channels/nixos-20.09 stable`.

# Some packages are installed outside of Nix, just because I can't get them to work.
# - rofi (starting evolution via nix rofi spawned glibc issues)
# - evolution (i have a custom tray plugin and idk how to do it in nixos)
# - calibre (in nixos i just got errors firing it up)
# - alsa-utils (shared library error?)
# - foliate (not in nixpkgs)
#   - can install via flatpak, but need to enable filesystem access for cli to work properly
#   - sudo flatpak override com.github.johnfactotum.Foliate --filesystem=host

let
  stable = import <stable> {};
in
{
  programs.home-manager.enable = true;

  home.username = "blissful";
  home.homeDirectory = "/home/blissful";
  home.stateVersion = "21.05";

  ### Nix Shit

  programs.direnv.enable = true;
  programs.direnv.enableNixDirenvIntegration = true;

  ### Services

  imports = [
    ./fonts
    ./keybase
    ./polybar
    ./signal
  ];

  ### Packages

  programs.fish.enable = true;

  home.packages = with pkgs; [
    autossh
    firefox
    jq
    rnix-lsp
    slack
    spotify
    tdesktop
    zoom
    zotero

    # Overrides
    stable.discord
  ];
}
