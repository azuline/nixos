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
      set -eu
      ${pkgs.coreutils}/bin/echo "Hello World"
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "nobody";
    };
  };
}
