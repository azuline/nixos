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
      else if specialArgs.sys.host == "haiqin" then
        ''
          polybar haiqin &
        ''
      else throw "Invalid host for polybar."
    );
  };

  # The tray service doesn't already exist; need to define it.
  systemd.user.targets.tray = {
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
    Unit = {
      Description = "Home Manager System Tray";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
  };
}
