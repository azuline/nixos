job "saffron" {
  datacenters = ["neptune"]
  type        = "service"
  group "saffron" {
    count = 1
    network {
      mode = "bridge"
      port "http" {
        static = 29001
        to     = 80
      }
    }
    service {
      name     = "saffron"
      port     = "http"
      provider = "nomad"
      check {
        name     = "http check"
        type     = "http"
        path     = "/login"
        interval = "10s"
        timeout  = "2s"
      }
    }
    volume "data" {
      type   = "host"
      source = "saffron-data"
    }
    task "saffron" {
      driver = "docker"
      config {
        image = "blissful/saffron"
        args  = ["start", "-h", "0.0.0.0", "-p", "80"]
      }
      env {
        HOST_URL = "https://u.sunsetglow.net"
      }
      volume_mount {
        volume      = "data"
        destination = "/appdata"
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
