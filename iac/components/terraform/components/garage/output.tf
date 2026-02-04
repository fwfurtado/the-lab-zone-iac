output "garage" {
  value = {
    cluster = module.cluster
    ui = module.ui
  }
}

output "consul_token_accessor_id" {
  description = "Consul ACL token for Garage"
  value       = consul_acl_token.this.id
  sensitive   = true
}