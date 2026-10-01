resource "google_compute_region_health_check" "app" {
  project = var.project_id
  name    = "${var.environment}-flask-health-check"
  region  = var.region

  check_interval_sec  = 5
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 2

  http_health_check {
    port_specification = "USE_SERVING_PORT"
    request_path       = "/health"
    proxy_header       = "NONE"
  }
}


resource "google_compute_region_backend_service" "app" {
  project = var.project_id
  name    = "${var.environment}-flask-backend"
  region  = var.region

  protocol              = "HTTP"
  port_name             = "http"
  load_balancing_scheme = "EXTERNAL_MANAGED"

  health_checks = [
    google_compute_region_health_check.app.id
  ]

  backend {
    group           = var.instance_group
    balancing_mode  = "UTILIZATION"
    capacity_scaler = 1.0
  }
}


resource "google_compute_region_url_map" "app" {
  project = var.project_id
  name    = "${var.environment}-flask-url-map"
  region  = var.region

  default_service = google_compute_region_backend_service.app.id
}


resource "google_compute_region_target_http_proxy" "app" {
  project = var.project_id
  name    = "${var.environment}-flask-http-proxy"
  region  = var.region

  url_map = google_compute_region_url_map.app.id
}


resource "google_compute_address" "lb_ip" {
  project      = var.project_id
  name         = "${var.environment}-flask-lb-ip"
  region       = var.region
  address_type = "EXTERNAL"

  network_tier = "STANDARD"
}


resource "google_compute_forwarding_rule" "http" {
  project = var.project_id
  name    = "${var.environment}-flask-http-forwarding-rule"
  region  = var.region

  ip_protocol           = "TCP"
  port_range            = "80"
  load_balancing_scheme = "EXTERNAL_MANAGED"

  target     = google_compute_region_target_http_proxy.app.id
  ip_address = google_compute_address.lb_ip.id

  network      = var.network_id
  network_tier = "STANDARD"
}
