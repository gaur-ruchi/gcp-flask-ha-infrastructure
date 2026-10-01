output "load_balancer_ip" {
  description = "External IP address of the Application Load Balancer"
  value       = google_compute_address.lb_ip.address
}

output "backend_service_id" {
  description = "Regional backend service ID"
  value       = google_compute_region_backend_service.app.id
}

output "health_check_id" {
  description = "Regional health check ID"
  value       = google_compute_region_health_check.app.id
}

output "url_map_id" {
  description = "Regional URL map ID"
  value       = google_compute_region_url_map.app.id
}
