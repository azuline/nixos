{ pkgs, ... }:

{
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    # plata-theme
    # papirus-icon-theme

    font-awesome
    # Nerd Fonts contains patched fonts (incl. Iosevka)
    nerdfonts
    twitter-color-emoji
    noto-fonts
    source-code-pro
    source-sans-pro
    noto-fonts-cjk
  ];
}
