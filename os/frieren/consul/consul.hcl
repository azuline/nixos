datacenter = "frieren"
data_dir   = "/data/consul"
log_level  = "INFO"

acl {
  enabled                  = true
  default_policy           = "deny"
  enable_token_persistence = true
}

performance {
  raft_multiplier = 1
}

# Server config.
server           = true
bootstrap_expect = 1
bind_addr        = "100.71.28.44"
client_addr      = "100.71.28.44"

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
