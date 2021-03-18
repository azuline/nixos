{ config, lib, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "blissful";
  home.homeDirectory = "/home/blissful";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.03";

  services.keybase.enable = true;
  services.kbfs.enable = true;

  programs.go.enable = true;

  home.packages = with pkgs; [
    discord
    feh
    firefox
    neofetch
    pass
    tdesktop
    slack
    ungoogled-chromium
    blueman
    weechat
    zoom-us
    spotify
    keybase-gui
  ]; 
}
