{ pkgs, ... }:

{
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    font-awesome
    iosevka
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    twitter-color-emoji
  ];
}
