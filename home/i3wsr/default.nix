{ pkgs, ... }:

{
  home.packages = [ pkgs.i3wsr ];
  xdg.configFile."i3wsr/config.toml".source = ./config.toml;
  systemd.user.services = {
    i3wsr = {
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
      Service = {
        Restart = "on-failure";
        # Ensure that i3wsr can call i3 to get the socket path.
        ExecStart = "${pkgs.i3wsr}/bin/i3wsr";
        Environment = "PATH=${pkgs.i3}/bin:$PATH";
        Type = "forking";
      };
      Unit = {
        After = "graphical-session-pre.target";
        PartOf = "graphical-session.target";
      };
    };
  };
}
