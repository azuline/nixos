datacenter = "zen"
data_dir   = "/data/nomad"
bind_addr  = "100.71.28.44"

server {
  enabled          = true
  bootstrap_expect = 1
}

client {
  enabled = true
  host_network "default" {
    cidr = "100.71.28.44/32"
  }
  host_network "public" {
    cidr           = "147.135.1.125/32"
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
  host_volume "thelounge-config" {
    path = "/data/thelounge/config"
  }
}

ui {
  enabled = true
}

consul {
  address      = "100.71.28.44:8500"
  grpc_address = "100.71.28.44:8502"
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