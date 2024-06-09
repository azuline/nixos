{ pkgs, ... }:

{
  home.packages = [ pkgs.figma-agent ];

  systemd.user.services.figma-agent = {
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.figma-agent}/bin/figma-agent";
      Restart = "always";
    };
    Unit = {
      After = "graphical-session-pre.target";
      PartOf = "graphical-session.target";
    };
  };
}
