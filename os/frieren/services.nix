{ pkgs-stable, pkgs-latest, ... }:

let
  nomadConfig = "/etc/nixos/os/frieren/nomad";
  consulConfig = "/etc/nixos/os/frieren/consul";
in
{
  environment.systemPackages = with pkgs-stable; [
    pkgs-latest.nomad_1_8
    pkgs-latest.consul
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
    NOMAD_ADDR = "http://100.84.146.55:4646";
    CONSUL_HTTP_ADDR = "http://100.84.146.55:8500";
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
    path = with pkgs-stable; [ pkgs-latest.nomad_1_8 pkgs-latest.consul iproute iptables cni-plugins ];
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      User = "root";
      Group = "root";
      ExecReload = "/bin/kill -HUP $MAINPID";
      ExecStart = "@${pkgs-latest.nomad_1_8}/bin/nomad nomad agent -config ${nomadConfig}";
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
    path = with pkgs-stable; [ pkgs-latest.consul envoy iproute iptables cni-plugins ];
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      User = "consul";
      Group = "consul";
      ExecReload = "/bin/kill -HUP $MAINPID";
      ExecStart = "@${pkgs-latest.consul}/bin/consul consul agent -config-dir=${consulConfig}";
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

  security.acme = {
    acceptTerms = true;
    defaults.email = "blissful@sunsetglow.net";
    certs."sunsetglow.net" = {
      domain = "sunsetglow.net";
      extraDomainNames = [ "*.sunsetglow.net" ];
      dnsProvider = "porkbun";
      environmentFile = "/secrets/acme/credentials";
      postRun = ''
        source /secrets/acme/nomad.env
        ${pkgs-latest.nomad_1_8}/bin/nomad job allocs -json nginx | ${pkgs-stable.jq}/bin/jq -r '.[0].ID' | ${pkgs-stable.findutils}/bin/xargs ${pkgs-latest.nomad_1_8}/bin/nomad alloc restart
      '';
    };
  };
}
