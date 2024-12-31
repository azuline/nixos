datacenter = "neptune"
data_dir   = "/data/consul"
log_level  = "INFO"

acl {
  enabled        = true
  default_policy = "deny"
}

performance {
  raft_multiplier = 1
}

# Server config.
server           = true
bootstrap_expect = 1
bind_addr        = "100.104.105.144"
client_addr      = "100.104.105.144"

# Consul service mesh.
connect {
  enabled = true
}
ports {
  grpc = 8502
}

ui_config {
  enabled = true
}

telemetry {
  disable_hostname          = true
  prometheus_retention_time = "24h"
}
