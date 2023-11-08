{ pkgs, ... }:

{
  systemd.user.services."cdrama-rss" = {
    Unit.Description = "cdrama rss trigger";
    Service.ExecStart = "${pkgs.bash}/bin/bash /home/blissful/scripts/cdrama/run.sh";
    Install.WantedBy = [ "default.target" ];
    serviceConfig.Type = "oneshot";
  };
  systemd.user.timers."cdrama-rss" = {
    Unit.Description = "cdrama rss trigger";
    Timer = {
      OnCalendar = "hourly";
      Persistent = true;
    };
    Install.WantedBy = [ "timers.target" ];
  };
}
