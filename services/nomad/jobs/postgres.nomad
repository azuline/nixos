job "postgres" {
  datacenters = ["neptune"]
  type        = "service"
  group "postgres" {
    count = 1
    network {
      mode = "bridge"
    }
    service {
      name = "postgres"
      port = "5432"
      connect {
        sidecar_service {}
      }
      check {
        name     = "pg_isready"
        type     = "script"
        command  = "/bin/sh"
        args     = ["-c", "pg_isready -h 127.0.0.1 -p 5432"]
        interval = "10s"
        timeout  = "2s"
        task     = "postgres"
      }
    }
    volume "data" {
      type   = "host"
      source = "postgres-data"
    }
    task "postgres" {
      driver = "docker"
      config {
        image = "postgres:16.3"
      }
      env {
        POSTGRES_DB       = "umami"
        POSTGRES_USER     = "umami"
        POSTGRES_PASSWORD = "umami"
      }
      resources {
        cpu    = 100
        memory = 4096
      }
      volume_mount {
        volume      = "data"
        destination = "/var/lib/postgresql/data"
      }
    }
  }
}
