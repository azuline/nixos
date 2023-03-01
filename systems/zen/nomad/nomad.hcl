datacenter = "zen"
data_dir = "/data/nomad"
bind_addr = "100.71.28.44"

server {
  enabled = true
  bootstrap_expect = 1
}

client {
  enabled = true
  host_network "tailscale" {
    cidr = "100.71.28.44/32"
    reserved_ports = "22"
  }
}

ui {
  enabled = true
}
