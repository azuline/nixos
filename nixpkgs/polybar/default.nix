{ pkgs, specialArgs, ... }:

{
  services.polybar = {
    enable = true;
    package = pkgs.polybarFull;
    config = ./config.ini;
    script = (
      if specialArgs.host == "splendor" then
        ''
          polybar left &
          polybar right &
        ''
      else if specialArgs.host == "neptune" then
        ''
          polybar neptune &
        ''
      else throw "Invalid host for polybar."
    );
  };
}
