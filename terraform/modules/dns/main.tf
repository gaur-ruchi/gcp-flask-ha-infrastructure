resource "google_dns_managed_zone" "public" {
  project     = var.project_id
  name        = "${var.environment}-public-zone"
  dns_name    = var.domain_name
  description = "Public DNS zone for ${var.domain_name}"

  visibility = "public"
}

resource "google_dns_record_set" "app" {
  project      = var.project_id
  managed_zone = google_dns_managed_zone.public.name

  name = var.domain_name
  type = "A"
  ttl  = 300

  rrdatas = [var.load_balancer_ip]
}
