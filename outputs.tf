output "id" {
  value       = google_memcache_instance.main.id
  description = "ID of the Memcached instance"
}

output "discovery_endpoint" {
  value       = google_memcache_instance.main.discovery_endpoint
  description = "Discovery endpoint clients use to find the Memcached nodes"
}

output "nodes" {
  value       = google_memcache_instance.main.memcache_nodes
  description = "Memcached nodes (host, port, zone and state)"
}
