output "environment" {
  description = "The environment name"
  value       = var.environment
}

output "region" {
  description = "The GCP region"
  value       = var.region

}

output "app_cidr" {
  description = "The APP CIDR block"
  value       = var.app_subnet_cidr

}

output "proxy_cidr" {
  description = "The PROXY CIDR block"
  value       = var.proxy_subnet_cidr

}

output "service_account_email" {
  description = "The service account email used by the Flask VMs"
  value       = module.compute.service_account_email

}

output "load_balancer_ip" {
  description = "The external IP address of the Application Load Balancer"
  value       = module.load_balancer.load_balancer_ip

}

output "name_servers" {
  description = "The name servers for the public DNS zone"
  value       = module.dns.name_servers

}

output "dns_record" {
  description = "The DNS A record for the public DNS zone"
  value       = module.dns.dns_record
}
