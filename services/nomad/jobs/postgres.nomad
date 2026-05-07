job "postgres" {
  datacenters = ["neptune"]
  type        = "service"
  group "postgres" {
    count = 1
    network {
      mode = "bridge"
      port "db" {
        static = 29005
        to     = 5432
      }
    }
    service {
      name     = "postgres"
      port     = "db"
      provider = "nomad"
      check {
        name     = "pg_isready"
        type     = "tcp"
        port     = "db"
        interval = "10s"
        timeout  = "2s"
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
