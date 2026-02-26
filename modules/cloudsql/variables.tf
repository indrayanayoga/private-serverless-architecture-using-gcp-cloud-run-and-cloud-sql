variable "region" {
  description = "GCP region"
  type        = string
}

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

variable "vpc_id" {
  description = "VPC self link for private IP"
  type        = string
}

variable "service_account_email" {
  description = "Service account for IAM auth"
  type        = string
}

# Production controls

variable "deletion_protection" {
  description = "Enable deletion protection"
  type        = bool
  default     = true
}

variable "availability_type" {
  description = "Availability type"
  type        = string
  default     = "REGIONAL"
}

variable "disk_type" {
  description = "Disk type"
  type        = string
  default     = "PD_SSD"
}

variable "disk_size" {
  description = "Disk size in GB"
  type        = number
  default     = 20
}

variable "backups_enabled" {
  description = "Enable backups"
  type        = bool
  default     = true
}

variable "backup_start_time" {
  description = "Backup start time"
  type        = string
  default     = "03:00"
}

variable "pitr_enabled" {
  description = "Enable point-in-time recovery"
  type        = bool
  default     = true
}

# Read Replica Configuration

variable "enable_read_replica" {
  description = "Enable read replica for load distribution"
  type        = bool
  default     = false
}
