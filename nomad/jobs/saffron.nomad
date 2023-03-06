job "saffron" {
  datacenters = ["zen"]

  group "saffron" {
    count = 1

    network {
      mode = "bridge"
    }

    service {
      name = "saffron"
      port = "80"
      connect {
        sidecar_service {}
      }
    }

    volume "data" {
      type   = "host"
      source = "saffron-data"
    }

    task "saffron" {
      driver = "docker"
      env {
        HOST_URL = "https://u.sunsetglow.net"
      }
      config {
        image   = "blissful/saffron"
        args    = ["start", "-h", "0.0.0.0", "-p", "80"]
      }
      volume_mount {
        volume      = "data"
        destination = "/appdata"
      }
    }
  }
}
