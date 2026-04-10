variable "gcp_svc_key" {
  description = "Path to the GCP service account key file"
  type        = string
}


variable "gcp_project" {
  description = "GCP project ID"
  type        = string
}


variable "gcp_region" {
  description = "GCP region for resources"
  type        = string
}

variable "dns_zone_name" {
  description = "Name of the existing DNS zone in Cloud DNS"
  type        = string
}