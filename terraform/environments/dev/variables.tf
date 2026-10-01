variable "environment" {
  description = "The environment name"
  type        = string

}

variable "project_id" {
  description = "The GCP project ID"
  type        = string

}

variable "region" {
  description = "The GCP region"
  type        = string

}

variable "zone" {
  description = "The GCP zone"
  type        = string

}

variable "app_subnet_cidr" {
  description = "The CIDR range for the app subnet"
  type        = string

}

variable "proxy_subnet_cidr" {
  description = "The CIDR range for the proxy subnet"
  type        = string
}

variable "machine_type" {
  description = "The machine type for the instances"
  type        = string

}

variable "os_image" {
  description = "The OS image to use for the instances"
  type        = string

}

variable "boot_disk_size_gb" {
  description = "The size of the boot disk in GB"
  type        = number

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

variable "domain_name" {
  description = "Fully qualified domain name for the public DNS zone"
  type        = string
}
