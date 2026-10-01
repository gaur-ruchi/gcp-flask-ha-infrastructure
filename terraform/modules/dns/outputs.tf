output "managed_zone_name" {
  description = "Cloud DNS managed zone name"
  value       = google_dns_managed_zone.public.name
}

output "name_servers" {
  description = "Authoritative Google Cloud DNS name servers"
  value       = google_dns_managed_zone.public.name_servers
}

output "dns_record" {
  description = "DNS A record"
  value       = google_dns_record_set.app.name
}
