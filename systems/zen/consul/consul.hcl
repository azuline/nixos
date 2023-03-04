datacenter = "zen"
data_dir   = "/data/consul/data"

# tls {
#   defaults {
#     ca_file         = "/data/consul/certs/consul-agent-ca.pem"
#     cert_file       = "/data/consul/certs/zen-server-consul-0.pem"
#     key_file        = "/data/consul/certs/zen-server-consul-0-key.pem"
#     verify_incoming = true
#     verify_outgoing = true
#   }
#   internal_rpc {
#     verify_server_hostname = true
#   }
# }

# auto_encrypt {
#   allow_tls = true
# }

acl {
  enabled = true
  # TODO: Make false after bootstrap.
  default_policy           = "allow"
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
addresses {
  grpc = "100.71.28.44"
}
ports {
  grpc = 8502
}

ui_config {
  enabled = true
}
