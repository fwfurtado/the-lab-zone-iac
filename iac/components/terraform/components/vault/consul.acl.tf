resource "consul_acl_policy" "vault" {
  name        = "vault"
  description = "Vault cluster - service registration and HA coordination"
  datacenters  = [var.consul_datacenter]

  rules = <<-EOF
    service "vault" {
      policy = "write"
    }
    check_prefix "vault" {
      policy = "write"
    }
    session_prefix "" {
      policy = "write"
    }
    key_prefix "vault/" {
      policy = "write"
    }
    node_prefix "" {
      policy = "read"
    }
    agent_prefix "" {
      policy = "write"
    }
  EOF
}

resource "consul_acl_token" "vault" {
  description = "Vault cluster token"
  policies    = [consul_acl_policy.vault.name]
  local       = false
}