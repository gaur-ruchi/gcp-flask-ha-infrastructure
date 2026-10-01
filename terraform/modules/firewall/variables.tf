variable "environment" {
  description = "The environment name"
  type        = string

}

variable "project_id" {
  description = "The GCP project ID"
  type        = string

}

variable "network_id" {
  description = "ID of the VPC network"
  type        = string
}

variable "proxy_subnet_cidr" {
  description = "CIDR range of the regional proxy-only subnet"
  type        = string
}