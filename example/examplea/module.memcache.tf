# holden:ignore:HLD_TF_026 — examples intentionally use ../../ to reference the local module root
# holden:ignore:HLD_TF_065 — the module adds input validation and secure defaults (deletion protection, pinned version, maintenance window, no default network)
module "memcache" {
  source               = "../../"
  name                 = "example-memcache"
  region               = "europe-west2"
  authorized_network   = google_service_networking_connection.private_service_access.network
  reserved_ip_range_id = [google_compute_global_address.private_service_access.name]

  labels = {
    team = "web"
  }
}
