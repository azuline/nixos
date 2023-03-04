{ pkgs, ... }:

let
  nomadConfig = builtins.path { path = ./nomad; name = "nomad"; };
in
{
  environment.systemPackages = with pkgs; [
    nomad
    consul
  ];

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
}
