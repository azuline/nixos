{ pkgs, config, specialArgs, ... }:

{
  # Rose is already on the $PATH because we build it into Python (so we can script against it).

  xdg.configFile."rose/config.toml".source = config.lib.file.mkOutOfStoreSymlink "${specialArgs.sys.nixDir}/home/rose/config.toml";

  # Ensure the Home Manager systemd services are enabled
  systemd.user.services.rose = {
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.rose}/bin/rose fs mount --foreground";
      Restart = "always";
    };
    Unit = {
      After = "graphical-session-pre.target";
      PartOf = "graphical-session.target";
    };
  };
}
