resource "google_compute_router" "router" {
  project = var.project_id
  name    = "${var.environment}-cloud-router"
  region  = var.region
  network = var.network_id
}

resource "google_compute_router_nat" "nat" {
  project = var.project_id
  name    = "${var.environment}-cloud-nat"

  router = google_compute_router.router.name
  region = var.region

  nat_ip_allocate_option             = "AUTO_ONLY" #Google automatically allocates external NAT IP addresses for the gateway.
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    name                    = var.app_subnet_id
    source_ip_ranges_to_nat = ["PRIMARY_IP_RANGE"]
  }

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}
