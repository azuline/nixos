name        = "blossom"
description = "blossom services namespace"

capabilities {
  enabled_task_drivers  = ["docker", "exec"]
  disabled_task_drivers = ["raw_exec"]
}
