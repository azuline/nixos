{ pkgs, ... }:

{
  home.packages = [ pkgs.i3wsr ];

  systemd.user.services = {
    i3wsr = {
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
      Service = {
        Restart = "on-failure";
        # Ensure that i3wsr can call i3 to get the socket path.
        ExecStart = "/usr/bin/env PATH=${pkgs.i3}/bin:$PATH ${pkgs.i3wsr}/bin/i3wsr";
        Type = "forking";
      };
      Unit = {
        After = "graphical-session-pre.target";
        PartOf = "graphical-session.target";
      };
    };
  };
}
