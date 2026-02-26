output "lb_ip" {
  description = "Load balancer IP address"
  value       = google_compute_global_forwarding_rule.https.ip_address
}

output "https_forwarding_rule" {
  description = "HTTPS forwarding rule ID"
  value       = google_compute_global_forwarding_rule.https.id
}

output "backend_service" {
  description = "Backend service ID"
  value       = google_compute_backend_service.backend.id
}