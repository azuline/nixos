job "thelounge" {
  datacenters = ["frieren"]
  type = "service"
  group "thelounge" {
    count = 1
    network {
      mode = "bridge"
      port "http" {
        static = 9001
        to     = 9000
      }
    }
    volume "config" {
      type   = "host"
      source = "thelounge-config"
    }
    task "thelounge" {
      driver = "docker"
      env {
        PUID = "1000"
        PGID = "1000"
        TZ   = "Etc/UTC"
      }
      config {
        image = "lscr.io/linuxserver/thelounge"
        ports = ["http"]
      }
      volume_mount {
        volume      = "config"
        destination = "/config"
      }
    }
  }
}
