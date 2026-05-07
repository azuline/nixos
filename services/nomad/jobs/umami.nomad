job "umami" {
  datacenters = ["neptune"]
  type        = "service"
  group "umami" {
    count = 1
    network {
      mode = "bridge"
      port "http" {
        static = 29004
        to     = 3000
      }
    }
    service {
      name     = "umami"
      port     = "http"
      provider = "nomad"
      check {
        type     = "http"
        path     = "/api/heartbeat"
        interval = "10s"
        timeout  = "2s"
      }
    }
    task "umami" {
      driver = "docker"
      config {
        image = "ghcr.io/umami-software/umami:3.0.2"
      }
      template {
        data        = <<EOF
DATABASE_URL=postgresql://umami:umami@{{ env "attr.unique.network.ip-address" }}:29005/umami
EOF
        destination = "secrets/env"
        env         = true
      }
      resources {
        cpu    = 100
        memory = 1024
      }
    }
  }
  update {
    max_parallel      = 1
    health_check      = "checks"
    min_healthy_time  = "10s"
    healthy_deadline  = "1m"
    progress_deadline = "10m"
    auto_revert       = true
    auto_promote      = true
    canary            = 1
  }
}
