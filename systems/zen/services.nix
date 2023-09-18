{ pkgs-stable, ... }:

let
  nomadConfig = "/etc/nixos/systems/zen/nomad";
  consulConfig = "/etc/nixos/systems/zen/consul";
in
{
  environment.systemPackages = with pkgs-stable; [
    nomad
    consul
    envoy
    opentelemetry-collector-contrib
  ];

  # Install CNI plugins into /opt/cni.
  system.activationScripts.cni.text = ''
    mkdir -p /opt
    rm -f /opt/cni
    ln -sf ${pkgs-stable.cni-plugins} /opt/cni
  '';

  environment.variables = {
    NOMAD_ADDR = "http://100.71.28.44:4646";
    CONSUL_HTTP_ADDR = "http://100.71.28.44:8500";
  };

  users = {
    users = {
      consul = {
        isSystemUser = true;
        group = "consul";
        uid = 1002;
      };
      otel = {
        isSystemUser = true;
        group = "otel";
        uid = 1003;
      };
    };
    groups = {
      consul.gid = 1002;
      otel.gid = 1003;
    };
  };

  # Need to configure network namespace for Consul.
  # https://developer.hashicorp.com/nomad/docs/integrations/consul-connect#cni-plugins
  boot.kernel.sysctl = {
    "net.bridge.bridge-nf-call-arptables" = 1;
    "net.bridge.bridge-nf-call-ip6tables" = 1;
    "net.bridge.bridge-nf-call-iptables" = 1;
  };

  systemd.services.nomad = {
    path = with pkgs-stable; [ nomad consul iproute iptables cni-plugins ];
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      User = "root";
      Group = "root";
      ExecReload = "/bin/kill -HUP $MAINPID";
      ExecStart = "@${pkgs-stable.nomad}/bin/nomad nomad agent -config ${nomadConfig}";
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
    path = with pkgs-stable; [ consul envoy iproute iptables cni-plugins ];
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      User = "consul";
      Group = "consul";
      ExecReload = "/bin/kill -HUP $MAINPID";
      ExecStart = "@${pkgs-stable.consul}/bin/consul consul agent -config-dir=${consulConfig}";
      KillMode = "process";
      KillSignal = "SIGTERM";
      LimitNOFILE = 65536;
      Restart = "on-failure";
      RestartSec = 2;
      OOMScoreAdjust = -1000;
    };
  };

  systemd.services.otelcollector = {
    path = with pkgs-stable; [ opentelemetry-collector-contrib ];
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      User = "otel";
      Group = "otel";
      ExecReload = "/bin/kill -HUP $MAINPID";
      ExecStart = "${pkgs-stable.opentelemetry-collector-contrib}/bin/otelcontribcol --config=file:/data/otel/config.yaml";
      KillMode = "process";
      KillSignal = "SIGTERM";
      LimitNOFILE = 65536;
      Restart = "on-failure";
      RestartSec = 2;
      OOMScoreAdjust = -1000;
    };
  };
}
