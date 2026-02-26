output "load_balancer_ip" {
  description = "Load balancer IP address"
  value       = module.loadbalancing.lb_ip
}