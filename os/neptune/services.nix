{ pkgs-stable, ... }:

let
  nomad = pkgs-stable.nomad;
  opentelemetry-collector-contrib = pkgs-stable.opentelemetry-collector-contrib;
  cni-plugins = pkgs-stable.cni-plugins;
  iproute = pkgs-stable.iproute2;
  iptables = pkgs-stable.iptables;

  nomadConfig = "/etc/nixos/os/neptune/nomad";
in
{
  environment.systemPackages = [
    nomad
    opentelemetry-collector-contrib
  ];

  # Install CNI plugins into /opt/cni.
  system.activationScripts.cni.text = ''
    mkdir -p /opt
    rm -f /opt/cni
    ln -sf ${cni-plugins} /opt/cni
  '';

  environment.variables = {
    NOMAD_ADDR = "http://100.104.105.144:4646";
  };

  users = {
    users = {
      otel = {
        isSystemUser = true;
        group = "otel";
        uid = 1003;
      };
    };
    groups = {
      otel.gid = 1003;
    };
  };

  # CNI bridge networking still needs these sysctls for Nomad bridge mode.
  boot.kernel.sysctl = {
    "net.bridge.bridge-nf-call-arptables" = 1;
    "net.bridge.bridge-nf-call-ip6tables" = 1;
    "net.bridge.bridge-nf-call-iptables" = 1;
  };

  systemd.services.nomad = {
    path = [
      nomad
      iproute
      iptables
      cni-plugins
    ];
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      User = "root";
      Group = "root";
      ExecReload = "/bin/kill -HUP $MAINPID";
      ExecStart = "@${nomad}/bin/nomad nomad agent -config ${nomadConfig}";
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

  systemd.services.otelcollector = {
    path = [ opentelemetry-collector-contrib ];
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      User = "otel";
      Group = "otel";
      ExecReload = "/bin/kill -HUP $MAINPID";
      ExecStart = "${opentelemetry-collector-contrib}/bin/otelcontribcol --config=file:/data/otel/config.yaml";
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
        ${nomad}/bin/nomad job allocs -json router | ${pkgs-stable.jq}/bin/jq -r '.[0].ID' | ${pkgs-stable.findutils}/bin/xargs ${nomad}/bin/nomad alloc restart
      '';
    };
  };
}
