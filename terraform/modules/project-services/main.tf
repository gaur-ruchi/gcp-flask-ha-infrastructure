resource "google_project_service" "required_apis" {
  for_each = toset([
    "compute.googleapis.com",
    "iam.googleapis.com",
    "dns.googleapis.com"
  ])

  project = var.project_id
  service = each.value

  disable_on_destroy = false
}
