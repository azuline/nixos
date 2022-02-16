{ pkgs, ... }:

{
  xdg.configFile."swaylock/config".source = ./config;

  # Doesn't seem to work.
  # home.packages = [
  #   pkgs.swaylock
  # ];
}
