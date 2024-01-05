job "presage" {
  datacenters = ["frieren"]
  type        = "batch"

  periodic {
    cron             = "0 */2 * * *"
    prohibit_overlap = true
  }

  group "presage" {
    volume "data" {
      type   = "host"
      source = "presage-data"
    }
    volume "nix" {
      type      = "host"
      source    = "nix"
      read_only = true
    }
    volume "run" {
      type      = "host"
      source    = "run"
      read_only = true
    }
    
    restart {
      attempts = 0
      mode     = "fail"
    }
    reschedule {
      attempts  = 0
      unlimited = false
    }

    task "presage" {
      driver = "exec"
      user   = "cron"
      volume_mount {
        volume      = "data"
        destination = "/data/presage"
      }
      volume_mount {
        volume      = "nix"
        destination = "/nix"
      }
      volume_mount {
        volume      = "run"
        destination = "/run"
      }
      config {
        command = "/run/current-system/sw/bin/presage"
        args    = ["-env-file", "/data/presage/env", "-feeds-list", "/data/presage/feeds.txt", "-send-to", "suiyun@riseup.net"]
      }
    }
  }
}
