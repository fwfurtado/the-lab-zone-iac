output "cockroachdb" {
  value = module.this
}

output "consul_token_accessor_id" {
  description = "Consul ACL token for Vault"
  value       = consul_acl_token.this.id
  sensitive   = true
}


output "ips" {
  value = local.ips
}

output "join_addresses" {
  value = local.join_addresses
}