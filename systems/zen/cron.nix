{ config, lib, pkgs, ... }:

{
  systemd.timers."presage" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "2h";
      OnUnitActiveSec = "2h";
      Unit = "presage.service";
    };
  };
  systemd.services."presage" = {
    script = ''
      ${pkgs.presage}/bin/presage -env-file /data/presage/env -feeds-list /data/presage/feeds.txt -send-to suiyun@riseup.net
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "cron";
      Group = "presage";
    };
  };
}
