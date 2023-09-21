{ pkgs, ... }:

{
  home.packages = with pkgs; [
    i3-atelier-identifier
    i3-atelier-opener
    i3-yy
  ];

  systemd.user.services = {
    atelier = {
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
      Service = {
        Restart = "on-failure";
        ExecStart = "/run/current-system/sw/bin/nix develop --command bash -c \"python -m _tool.daemon\"";
        Environment = "PATH=/home/blissful/.nix-profile/bin:/run/current-system/sw/bin";
        WorkingDirectory = "/home/blissful/atelier";
      };
      Unit = {
        After = "graphical-session-pre.target";
        PartOf = "graphical-session.target";
      };
    };
  };
}
