{ pkgs, specialArgs, ... }:

{
  services.polybar = {
    enable = true;
    package = pkgs.polybarFull;
    config = ./config.ini;
    script = (
      if specialArgs.sys.host == "splendor" then
        ''
          polybar left &
          polybar right &
        ''
      else if specialArgs.sys.host == "neptune" then
        ''
          polybar neptune &
        ''
      else throw "Invalid host for polybar."
    );
  };
}
