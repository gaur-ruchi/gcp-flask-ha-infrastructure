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

variable "app_subnet_cidr" {
  description = "The CIDR range for the app subnet"
  type        = string

}

variable "proxy_subnet_cidr" {
  description = "The CIDR range for the proxy subnet"
  type        = string
}
