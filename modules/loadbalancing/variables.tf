variable "app_name" {
  description = "Application name"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
}

variable "project_id" {
  description = "project ID"
  type        = string
}

variable "cloud_run_service_name" {
  description = "Cloud Run service name"
  type        = string
}

variable "domain" {
  description = "Domain for SSL cert"
  type        = string
}

variable "ssl_certificate_name" {
  description = "Name of existing SSL certificate in Certificate Manager"
  type        = string
}

variable "security_policy_id" {
  description = "Cloud Armor policy ID"
  type        = string
  default     = null
}

variable "enable_http_redirect" {
  description = "Enable HTTP redirect"
  type        = bool
  default     = true
}