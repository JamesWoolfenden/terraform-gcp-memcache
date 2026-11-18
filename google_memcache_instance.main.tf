resource "google_memcache_instance" "main" {
  name                 = var.name
  region               = var.region
  display_name         = var.display_name
  authorized_network   = var.authorized_network
  reserved_ip_range_id = var.reserved_ip_range_id
  zones                = var.zones
  node_count           = var.node_count
  memcache_version     = var.memcache_version
  deletion_protection  = var.deletion_protection
  labels               = var.labels

  node_config {
    cpu_count      = var.cpu_count
    memory_size_mb = var.memory_size_mb
  }

  memcache_parameters {
    params = var.memcache_parameters
  }

  maintenance_policy {
    description = "Weekly maintenance window"

    weekly_maintenance_window {
      day      = var.maintenance_window.day
      duration = var.maintenance_window.duration

      start_time {
        hours   = var.maintenance_window.start_hour
        minutes = 0
        seconds = 0
        nanos   = 0
      }
    }
  }
}
