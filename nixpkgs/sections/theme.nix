{ pkgs, ... }:

{
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    plata-theme
    papirus-icon-theme

    font-awesome
    # Nerd Fonts contains patched fonts (incl. Iosevka + Noto)
    nerdfonts
    twitter-color-emoji
  ];
}
