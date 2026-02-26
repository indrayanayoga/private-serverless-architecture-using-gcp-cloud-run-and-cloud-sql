variable "app_name" {
  description = "Application name"
  type        = string
}

# Rate limiting controls
variable "rate_limit_requests" {
  description = "Requests per interval"
  type        = number
  default     = 200
}

variable "rate_limit_interval" {
  description = "Interval in seconds"
  type        = number
  default     = 60
}

variable "ban_duration_sec" {
  description = "Ban duration in seconds"
  type        = number
  default     = 300
}