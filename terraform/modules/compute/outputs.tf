output "instance_template_id" {
  description = "Regional instance template ID"
  value       = google_compute_region_instance_template.app.id
}

output "instance_template_name" {
  description = "Regional instance template name"
  value       = google_compute_region_instance_template.app.name
}

output "mig_id" {
  description = "Regional managed instance group manager ID"
  value       = google_compute_region_instance_group_manager.mig.id
}

output "instance_group" {
  description = "Underlying regional instance group used by the load balancer"
  value       = google_compute_region_instance_group_manager.mig.instance_group
}

output "mig_name" {
  description = "Regional MIG name"
  value       = google_compute_region_instance_group_manager.mig.name
}

output "service_account_email" {
  description = "Runtime service account attached to Flask VMs"
  value       = google_service_account.app.email
}

output "named_port" {
  description = "Named application port exposed by the MIG"
  value       = "http"
}
