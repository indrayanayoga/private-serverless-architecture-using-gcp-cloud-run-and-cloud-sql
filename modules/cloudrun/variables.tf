variable "app_name" {
  description = "Cloud Run service name"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
}

variable "image" {
  description = "Container image URL"
  type        = string
}

variable "service_account_email" {
  description = "Service account email"
  type        = string
}

# Scaling
variable "min_instances" {
  description = "Minimum instances"
  type        = number
  default     = 0
}

variable "max_instances" {
  description = "Maximum instances"
  type        = number
  default     = 10
}

# Resources
variable "cpu" {
  description = "CPU allocation"
  type        = string
  default     = "1"
}

variable "memory" {
  description = "Memory allocation"
  type        = string
  default     = "512Mi"
}

# Networking
variable "connector_id" {
  description = "VPC connector ID"
  type        = string
  default     = null
}

variable "vpc_egress" {
  description = "VPC egress setting"
  type        = string
  default     = "ALL_TRAFFIC"
}

variable "ingress" {
  description = "Ingress control"
  type        = string
  default     = "INGRESS_TRAFFIC_INTERNAL_LOAD_BALANCER"
}

# Environment Variables
variable "env_vars" {
  description = "Environment variables"
  type        = map(string)
  default     = {}
}

# IAM
variable "allow_public_access" {
  description = "Allow unauthenticated access"
  type        = bool
  default     = true
}