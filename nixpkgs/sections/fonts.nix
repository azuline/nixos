{ pkgs, ... }:

{
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    # Nerd Fonts contains Iosevka / Font Awesome / Fira Code / Noto
    nerdfonts
    twitter-color-emoji
  ];
}
