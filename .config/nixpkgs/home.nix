{ config, pkgs, ... }:

let
  stable = import
    (builtins.fetchTarball https://github.com/nixos/nixpkgs/tarball/20.09)
    { config = config.nixpkgs.config; };
in
{
  nixpkgs.config.allowUnfree = true;
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

  ## Packages

  programs.bash.enable = true;
  programs.fish.enable = true;

  home.packages = with pkgs; [
    autossh
    keybase-gui
    spotify
    slack
    jq
    tdesktop
    zotero
    stable.discord
    zoom
    rofi
    signal-desktop
  ];

  ### Fixes
  
  # Fixes locale for rofi.
  home.sessionVariables.LOCALES_ARCHIVE = "${pkgs.glibcLocales}/lib/locale/locale-archive";
}
