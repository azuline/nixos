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
        ExecStart = "${pkgs.i3wsr}/bin/i3wsr";
        Type = "forking";
      };
      Unit = {
        After = "graphical-session-pre.target";
        PartOf = "graphical-session.target";
      };
    };
  };
}
