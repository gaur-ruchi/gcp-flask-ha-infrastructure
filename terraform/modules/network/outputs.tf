output "vpc_name" {
  description = "VPC name"
  value       = google_compute_network.vpc.name
}

output "app_subnet" {
  description = "Application subnet name"
  value       = google_compute_subnetwork.app.name

}

output "proxy_subnet" {
  description = "Proxy subnet name"
  value       = google_compute_subnetwork.proxy.name

}

output "network_id" {
  description = "VPC network ID"
  value       = google_compute_network.vpc.id
}

output "app_subnet_id" {
  description = "Application subnet ID"
  value       = google_compute_subnetwork.app.id
}

output "proxy_subnet_id" {
  description = "Proxy subnet ID"
  value       = google_compute_subnetwork.proxy.id

}
