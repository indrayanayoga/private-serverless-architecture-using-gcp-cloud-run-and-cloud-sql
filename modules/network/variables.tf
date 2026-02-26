variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
}

variable "vpc_name" {
  description = "VPC network name"
  type        = string
}

# Subnets
variable "subnets" {
  description = "Map of subnets"
  type = map(object({
    cidr   = string
    region = string
  }))
}

# PSA
variable "enable_psa" {
  description = "Enable Private Service Access"
  type        = bool
  default     = false
}

variable "psa_range_name" {
  description = "PSA IP range name"
  type        = string
  default     = null
}

variable "psa_prefix_length" {
  description = "PSA prefix length"
  type        = number
  default     = 24
}

# Connector
variable "enable_connector" {
  description = "Enable VPC connector"
  type        = bool
  default     = false
}

variable "app_name" {
  description = "Application name"
  type        = string
  default     = null
}

variable "connector_cidr" {
  description = "VPC connector CIDR"
  type        = string
}