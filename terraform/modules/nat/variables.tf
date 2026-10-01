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

variable "network_id" {
  description = "ID of the VPC network"
  type        = string
}

variable "app_subnet_id" {
  description = "ID of the application subnet using Cloud NAT"
  type        = string
}
