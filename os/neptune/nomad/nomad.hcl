datacenter = "neptune"
data_dir   = "/data/nomad"
bind_addr  = "100.104.105.144"

server {
  enabled          = true
  bootstrap_expect = 1
}

client {
  enabled = true
  artifact {
    # https://github.com/hashicorp/nomad/issues/18721
    disable_filesystem_isolation = true
  }
  host_network "default" {
    cidr = "100.104.105.144/32"
  }
  host_network "public" {
    cidr           = "192.168.1.207/32"
    reserved_ports = "22"
  }
  host_volume "nix" {
    path      = "/nix"
    read_only = true
  }
  host_volume "run" {
    path      = "/run"
    read_only = true
  }
  host_volume "sunsetglow-certs" {
    path      = "/var/lib/acme"
    read_only = true
  }
  host_volume "sunsetglow-site" {
    path      = "/www"
    read_only = true
  }
  host_volume "presage-data" {
    path = "/data/presage"
  }
  host_volume "saffron-data" {
    path = "/data/saffron"
  }
  host_volume "postgres-data" {
    path = "/data/postgres"
  }
  host_volume "thelounge-config" {
    path = "/data/thelounge/config"
  }
}

ui {
  enabled = true
}

consul {
  address      = "100.104.105.144:8500"
  grpc_address = "100.104.105.144:8502"
}

acl {
  enabled = true
}

telemetry {
  collection_interval        = "1s"
  disable_hostname           = true
  publish_allocation_metrics = true
  publish_node_metrics       = true
  prometheus_metrics         = true
}
