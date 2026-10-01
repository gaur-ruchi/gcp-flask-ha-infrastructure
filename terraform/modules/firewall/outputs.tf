output "health_check_firewall_name" {
  description = "Firewall rule allowing load balancer health checks"
  value       = google_compute_firewall.health_check.name
}

output "lb_backend_firewall_name" {
  description = "Firewall rule allowing proxy traffic to application backends"
  value       = google_compute_firewall.lb_to_backend.name
}
