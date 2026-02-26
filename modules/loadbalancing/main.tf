# Serverless network endpoint group
resource "google_compute_region_network_endpoint_group" "serverless_neg" {
  name                  = "${var.app_name}-neg"
  region                = var.region
  network_endpoint_type = "SERVERLESS"

  cloud_run {
    service = var.cloud_run_service_name
  }
}

# Backend service
resource "google_compute_backend_service" "backend" {
  name                  = "${var.app_name}-backend"
  protocol              = "HTTP"
  load_balancing_scheme = "EXTERNAL_MANAGED"

  backend {
    group = google_compute_region_network_endpoint_group.serverless_neg.id
  }

  security_policy = var.security_policy_id
}

# URL map
resource "google_compute_url_map" "url_map" {
  name            = "${var.app_name}-urlmap"
  default_service = google_compute_backend_service.backend.id
}

# HTTPS forwarding rule
resource "google_compute_global_forwarding_rule" "https" {
  name                  = "${var.app_name}-https"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  target                = google_compute_target_https_proxy.https_proxy.id
  port_range            = "443"
}

# HTTP proxy for redirect
resource "google_compute_target_http_proxy" "http_proxy" {
  count = var.enable_http_redirect ? 1 : 0

  name    = "${var.app_name}-http-proxy"
  url_map = google_compute_url_map.url_map.id
}

#Certificate Map
#Reference existing Certificate that has been uploaded beforehand
resource "google_certificate_manager_certificate_map" "default" {
  name     = "cert-map"
}

resource "google_certificate_manager_certificate_map_entry" "default" {
  name            = "cert-map-entry"
  map             = google_certificate_manager_certificate_map.default.name
  certificates    = ["projects/${var.project_id}/locations/global/certificates/${var.ssl_certificate_name}"]
  hostname        = var.domain
}

# HTTPS proxy
resource "google_compute_target_https_proxy" "https_proxy" {
  name             = "${var.app_name}-https-proxy"
  url_map          = google_compute_url_map.url_map.id
  certificate_map = "//certificatemanager.googleapis.com/${google_certificate_manager_certificate_map.default.id}"
}

# HTTP forwarding rule
resource "google_compute_global_forwarding_rule" "http" {
  count = var.enable_http_redirect ? 1 : 0

  name                  = "${var.app_name}-http"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  target                = google_compute_target_http_proxy.http_proxy[0].id
  port_range            = "80"
}