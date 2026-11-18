# holden:ignore:HLD_GCP_094: Just enough to drive the module
# holden:ignore:HLD_GCP_303: Just enough to drive the module
# holden:ignore:HLD_GCP_093: Just enough to drive the module
resource "google_compute_network" "private" {
  name                    = "memcache-private"
  auto_create_subnetworks = false
}
