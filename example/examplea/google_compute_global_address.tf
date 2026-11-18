# holden:ignore:HLD_GCP_340: Just enough to drive the module — the PSA range is torn down with the example
resource "google_compute_global_address" "private_service_access" {
  name          = "memcache-psa-range"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 20
  network       = google_compute_network.private.id
}
