resource "google_service_account" "app" {
  project      = var.project_id
  account_id   = "${var.environment}-flask-app"
  display_name = "${var.environment} Flask application service account"
}


resource "google_compute_region_instance_template" "app" {
  project = var.project_id
  region  = var.region

  name_prefix = "${var.environment}-flask-template-"

  machine_type   = var.machine_type
  can_ip_forward = false

  tags = ["flask-backend"]

  labels = {
    environment = var.environment
    application = "flask"
  }

  disk {
    source_image = var.os_image
    disk_size_gb = var.boot_disk_size_gb
    boot         = true
    auto_delete  = true
  }

  network_interface {
    subnetwork = var.app_subnet_id
  }

  metadata_startup_script = file("${path.module}/startup.sh")

  service_account {
    email  = google_service_account.app.email
    scopes = ["cloud-platform"]
  }

  lifecycle {
    create_before_destroy = true
  }
}


resource "google_compute_region_instance_group_manager" "mig" {
  project = var.project_id
  name    = "${var.environment}-flask-mig"
  region  = var.region

  base_instance_name = "${var.environment}-flask"

  version {
    instance_template = google_compute_region_instance_template.app.id
    name              = "primary"
  }

  distribution_policy_zones = var.mig_zones

  named_port {
    name = "http"
    port = 8080
  }
}


resource "google_compute_region_autoscaler" "autoscaler" {
  project = var.project_id
  name    = "${var.environment}-flask-autoscaler"
  region  = var.region

  target = google_compute_region_instance_group_manager.mig.id

  autoscaling_policy {
    min_replicas    = var.min_replicas
    max_replicas    = var.max_replicas
    cooldown_period = 60

    cpu_utilization {
      target = 0.7
    }
  }
}
