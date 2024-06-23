job "umami" {
  datacenters = ["frieren"]
  type        = "service"
  group "umami" {
    count = 1
    network {
      mode = "bridge"
    }
    service {
      name = "umami"
      port = "3000"
      connect {
        sidecar_service {
          proxy {
            upstreams {
              destination_name = "postgres"
              local_bind_port  = 5432
            }
          }
        }
      }
      check {
        expose   = true
        type     = "http"
        path     = "/api/heartbeat"
        interval = "10s"
        timeout  = "2s"
      }
    }
    task "umami" {
      driver = "docker"
      config {
        image = "ghcr.io/umami-software/umami:postgresql-v2.12.0"
      }
      env {
        DATABASE_URL = "postgresql://umami:umami@${NOMAD_UPSTREAM_ADDR_postgres}/umami"
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

