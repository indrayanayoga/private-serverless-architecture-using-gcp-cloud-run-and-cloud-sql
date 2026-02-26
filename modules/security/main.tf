# Cloud Armor security policy
resource "google_compute_security_policy" "policy" {
  name = "${var.app_name}-armor"

  # Rate Limiting
  rule {
  action   = "rate_based_ban"
  priority = 1000

  match {
    versioned_expr = "SRC_IPS_V1"
    config {
      src_ip_ranges = ["*"]
    }
  }

  rate_limit_options {

    conform_action = "allow"

    exceed_action = "deny(429)"

    rate_limit_threshold {
      count        = var.rate_limit_requests
      interval_sec = var.rate_limit_interval
    }

    ban_duration_sec = var.ban_duration_sec
  }

  description = "Basic IP rate limiting"
}

  # OWASP WAF
  rule {
    action   = "deny(403)"
    priority = 2000

    match {
      expr {
        expression = "evaluatePreconfiguredWaf('sqli-v33-stable')"
      }
    }
    description = "OWASP CRS protection"
  }

  # Default Allow
  rule {
    action   = "allow"
    priority = 3000

    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = ["*"]
      }
    }

    description = "Default allow"
  }

  rule {
    action   = "deny(403)"
    priority = 2147483647

    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = ["*"]
      }
    }

    description = "Default deny"
  }
}