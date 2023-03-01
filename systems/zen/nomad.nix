{ config, lib, pkgs, ... }:

let
  config = builtins.path { path = ./nomad; name = "nomad"; };
in
{
  environment.systemPackages = with pkgs; [ nomad ];

  users.users.nomad = {
    isSystemUser = true;
    group = "nomad";
  };
  users.groups.nomad = { };

  systemd.services.nomad = {
    path = with pkgs; [ nomad iproute ];
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      User = "nomad";
      Group = "nomad";
      ExecReload = "/bin/kill -HUP $MAINPID";
      ExecStart = "@${pkgs.nomad}/bin/nomad nomad agent -config ${config}";
      KillMode = "process";
      KillSignal = "SIGINT";
      LimitNOFILE = 65536;
      LimitNPROC = "infinity";
      Restart = "on-failure";
      RestartSec = 2;
      TasksMax = "infinity";
      OOMScoreAdjust = -1000;
    };
  };
}
