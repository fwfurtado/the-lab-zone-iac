output "vault" {
  value = module.vault
}

output "consul_token_accessor_id" {
  description = "Consul ACL token for Vault"
  value       = consul_acl_token.vault.id
  sensitive   = true
}