variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
}

# App
variable "app_name" {
  description = "Application name"
  type        = string
}

# Network
variable "vpc_name" {
  description = "VPC network name"
  type        = string
}

variable "subnet_name" {
  description = "Subnet name"
  type        = string
}

variable "subnet_cidr" {
  description = "Subnet CIDR range"
  type        = string
}

variable "enable_psa" {
  description = "Enable Private Service Access"
  type        = bool
}

variable "psa_range_name" {
  description = "PSA IP range name"
  type        = string
}

variable "psa_prefix_length" {
  description = "PSA prefix length"
  type        = number
}

variable "enable_connector" {
  description = "Enable VPC connector"
  type        = bool
}

variable "connector_cidr" {
  description = "VPC connector CIDR"
  type        = string
}

# Cloud SQL
variable "instance_name" {
  description = "Cloud SQL instance name"
  type        = string
}

variable "db_name" {
  description = "Database name"
  type        = string
}

variable "db_tier" {
  description = "Database tier"
  type        = string
}

variable "disk_size" {
  description = "Disk size in GB"
  type        = number
}

variable "availability_type" {
  description = "Availability type"
  type        = string
}

variable "deletion_protection" {
  description = "Enable deletion protection"
  type        = bool
}

variable "backups_enabled" {
  description = "Enable backups"
  type        = bool
}

variable "pitr_enabled" {
  description = "Enable point-in-time recovery"
  type        = bool
}

variable "enable_read_replica" {
  description = "Enable read replica for load distribution"
  type        = bool
  default     = false
}

# Cloud Run
variable "cloud_run_image" {
  description = "Container image URL"
  type        = string
}

variable "min_instances" {
  description = "Minimum instances"
  type        = number
}

variable "max_instances" {
  description = "Maximum instances"
  type        = number
}

variable "cpu" {
  description = "CPU allocation"
  type        = string
}

variable "memory" {
  description = "Memory allocation"
  type        = string
}

# Load Balancer
variable "domain" {
  description = "Domain name"
  type        = string
}

variable "ssl_certificate_name" {
  description = "Name of existing SSL certificate in Certificate Manager"
  type        = string
}

# Security
variable "rate_limit_requests" {
  description = "Rate limit requests per interval"
  type        = number
}

variable "ban_duration_sec" {
  description = "Ban duration in seconds"
  type        = number
}

# Service Account
variable "service_account_name" {
  description = "Service account ID"
  type        = string
}