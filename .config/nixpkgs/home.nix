{ config, pkgs, ... }:

# Some packages are installed outside of Nix, just because I can't get them to work.
# - rofi (starting evolution via nix rofi spawned glibc issues)
# - evolution (i have a custom tray plugin and idk how to do it in nixos)
# - calibre (in nixos i just got errors firing it up)
# - alsa-utils (shared library error?)
# - foliate (not in nixpkgs)
#   - can install via flatpak, but need to enable filesystem access for cli to work properly
#   - sudo flatpak override com.github.johnfactotum.Foliate --filesystem=host

# TODO:
# - Add `--use-tray-icon` to signal's *.desktop (add a sed into installPHase)?

let
  stable = import <stable> {};
  signalWithTray = pkgs.signal-desktop.overrideAttrs (oldAttrs: rec {
    preFixup = oldAttrs.preFixup + ''
      substituteInPlace $out/share/applications/signal-desktop.desktop \
        --replace bin/signal-desktop 'bin/signal-desktop --use-tray-icon'
    '';
  });
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

  services.keybase.enable = true;
  services.kbfs.enable = true;

  services.polybar = {
    enable = true;
    package = pkgs.polybarFull;
    config = ./polybar/config.ini;
    script = ''
      polybar bottom &
    '';
  };

  ### Packages

  programs.fish.enable = true;
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    # Stable Overrides
    stable.discord

    # Packages
    autossh
    jq
    keybase-gui
    signalWithTray
    slack
    spotify
    tdesktop
    zoom
    zotero

    # Fonts
    font-awesome
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    twitter-color-emoji
  ];
}
