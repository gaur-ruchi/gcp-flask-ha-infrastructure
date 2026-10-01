variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
}

variable "app_subnet_id" {
  description = "Application subnet ID"
  type        = string
}

variable "machine_type" {
  description = "Compute Engine machine type"
  type        = string
  default     = "e2-micro"
}

variable "os_image" {
  description = "Boot disk image"
  type        = string
  default     = "ubuntu-os-cloud/ubuntu-2404-lts-amd64"
}

variable "boot_disk_size_gb" {
  description = "Boot disk size in GB"
  type        = number
  default     = 10
}

variable "mig_zones" {
  description = "Zones used by the regional MIG"
  type        = list(string)

}

variable "min_replicas" {
  description = "Minimum number of instances"
  type        = number
  default     = 2
}

variable "max_replicas" {
  description = "Maximum number of instances"
  type        = number
  default     = 5
}