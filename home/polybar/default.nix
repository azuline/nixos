{ pkgs, specialArgs, ... }:

{
  services.polybar = {
    enable = true;
    package = pkgs.polybarFull;
    config = ./config.ini;
    script = (
      if specialArgs.sys.host == "splendor" then
        ''
          # Only start if i3 socketpath succeeds.
          ${pkgs.i3-gaps}/bin/i3 --get-socketpath && polybar splendor-left &
          ${pkgs.i3-gaps}/bin/i3 --get-socketpath && polybar splendor-right &
        ''
      else if specialArgs.sys.host == "haiqin" then
        ''
          # Only start if i3 socketpath succeeds.
          ${pkgs.i3-gaps}/bin/i3 --get-socketpath && polybar haiqin &
        ''
      else throw "Unsupported host for polybar."
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
