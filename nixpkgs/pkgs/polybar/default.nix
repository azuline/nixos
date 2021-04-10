{ pkgs, ... }:

{
  services.polybar = {
    enable = true;
    package = pkgs.polybarFull;
    config = ./config.ini;
    script = ''
      polybar bottom &
    '';
  };
}
