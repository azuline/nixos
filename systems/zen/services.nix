{ pkgs, ... }:

let
  nomadConfig = "/etc/nixos/systems/zen/nomad";
  consulConfig = "/etc/nixos/systems/zen/consul";
in
{
  environment.systemPackages = with pkgs; [
    nomad
    consul
  ];

  users = {
    users = {
      consul = {
        isSystemUser = true;
        group = "consul";
        uid = 1002;
      };
    };
    groups = {
      consul.gid = 1002;
    };
  };

  systemd.services.nomad = {
    path = with pkgs; [ nomad iproute ];
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      User = "root";
      Group = "root";
      ExecReload = "/bin/kill -HUP $MAINPID";
      ExecStart = "@${pkgs.nomad}/bin/nomad nomad agent -config ${nomadConfig}";
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

  systemd.services.consul = {
    path = with pkgs; [ consul iproute ];
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      User = "consul";
      Group = "consul";
      ExecReload = "/bin/kill -HUP $MAINPID";
      ExecStart = "@${pkgs.consul}/bin/consul consul agent -config-dir=${consulConfig}";
      KillMode = "process";
      KillSignal = "SIGTERM";
      LimitNOFILE = 65536;
      Restart = "on-failure";
      RestartSec = 2;
      OOMScoreAdjust = -1000;
    };
  };
}
