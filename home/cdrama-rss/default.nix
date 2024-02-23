{ pkgs, ... }:

{
  systemd.user.services."cdrama-rss" = {
    Unit.Description = "cdrama rss trigger";
    Service.ExecStart = "${pkgs.bash}/bin/bash /home/blissful/scripts/cdrama/run.sh";
    Service.Type = "oneshot";
    Install.WantedBy = [ "default.target" ];
  };
  systemd.user.timers."cdrama-rss" = {
    Unit.Description = "cdrama rss trigger";
    Timer.OnCalendar = "hourly";
    Timer.Persistent = true;
    Install.WantedBy = [ "timers.target" ];
  };
}
