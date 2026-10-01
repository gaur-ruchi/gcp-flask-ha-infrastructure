resource "google_compute_firewall" "health_check" {
  project = var.project_id
  name    = "${var.environment}-allow-health-check"
  network = var.network_id

  direction = "INGRESS"

  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }

  source_ranges = [
    "35.191.0.0/16",
    "130.211.0.0/22"
  ]

  target_tags = ["flask-backend"]
}


resource "google_compute_firewall" "lb_to_backend" {
  project = var.project_id
  name    = "${var.environment}-allow-lb-to-backend"
  network = var.network_id

  direction = "INGRESS"

  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }

  source_ranges = [
    var.proxy_subnet_cidr
  ]

  target_tags = ["flask-backend"]
}


resource "google_compute_firewall" "allow_iap_ssh" {
  project = var.project_id
  name    = "${var.environment}-allow-iap-ssh"
  network = var.network_id

  direction = "INGRESS"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["35.235.240.0/20"]

  target_tags = ["flask-backend"]
}
