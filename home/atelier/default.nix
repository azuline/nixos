{ pkgs, ... }:

{
  systemd.user.services = {
    atelier = {
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
      Service = {
        Restart = "on-failure";
        ExecStart = "/run/current-system/sw/bin/nix develop --command bash -c \"python -m _tool.daemon\"";
        WorkingDirectory = "/home/blissful/atelier";
      };
      Unit = {
        After = "graphical-session-pre.target";
        PartOf = "graphical-session.target";
      };
    };
  };
}
