output "security_policy_id" {
  description = "Cloud Armor policy ID"
  value       = google_compute_security_policy.policy.id
}