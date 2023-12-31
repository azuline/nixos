{ pkgs, ... }:

{
  fonts.fontconfig.enable = true;
  # Real (not icon) fonts are in the private fonts repo outside of Nix.
  home.packages = with pkgs; [
    # Icon fonts.
    font-awesome_5
    iosevka-bin
  ];
}
