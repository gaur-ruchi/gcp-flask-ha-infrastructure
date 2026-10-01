resource "google_compute_network" "vpc" {
  project                 = var.project_id
  name                    = "${var.environment}-vpc"
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
}


resource "google_compute_subnetwork" "app" {
  project       = var.project_id
  name          = "${var.environment}-app-subnet"
  region        = var.region
  network       = google_compute_network.vpc.id
  ip_cidr_range = var.app_subnet_cidr

  private_ip_google_access = true
}


resource "google_compute_subnetwork" "proxy" {
  project       = var.project_id
  name          = "${var.environment}-proxy-subnet"
  region        = var.region
  network       = google_compute_network.vpc.id
  ip_cidr_range = var.proxy_subnet_cidr

  purpose = "REGIONAL_MANAGED_PROXY"
  role    = "ACTIVE"
}
