resource "consul_acl_policy" "service_registration" {
  name        = "traefik"
  description = "Traefik - service registration"

  rules = <<-EOF
    # Registrar qualquer serviço
    service_prefix "" {
      policy = "write"
    }

    # Registrar health checks
    check_prefix "" {
      policy = "write"
    }

    # Ler próprio nó (necessário para registro)
    node_prefix "" {
      policy = "read"
    }

    # Agent API (para registrar via HTTP API local)
    agent_prefix "" {
      policy = "write"
    }
  EOF
}

resource "consul_acl_token" "traefik" {
  description = "Traefik - service registration"
  policies    = [consul_acl_policy.service_registration.name]
}
