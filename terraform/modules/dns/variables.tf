variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "domain_name" {
  description = "Fully qualified domain name for the public DNS zone"
  type        = string
}

variable "load_balancer_ip" {
  description = "External IP address of the load balancer"
  type        = string
}
