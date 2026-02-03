locals {
  traefik = {
    config = {

      api = {
        dashboard = true
        insecure  = true
      }

      log = {
        level  = "INFO"
        format = "json"
      }

      ping = {
        manualRouting = false
      }

      metrics = {
        prometheus = {
          addEntryPointsLabels = true
          addServicesLabels    = true
        }
        # otlp = {
        #   addEntryPointsLabels = true
        #   addServicesLabels = true
        # }
      }

      entryPoints = {
        web = {
          address = ":80"
          http = {
            redirections = {
              entryPoint = {
                to     = "websecure"
                scheme = "https"
              }
            }
          }
        }

        websecure = {
          address = ":443"
        }
        "cockroachdb-sql-tls" = {
          address = ":26257"
        }
      }

      certificatesResolvers = {
        cloudflare = {
          acme = {
            email   = "fwfurtado@gmail.com"
            storage = "/traefik/acme/acme.json"
            dnsChallenge = {
              provider  = "cloudflare"
              resolvers = ["1.1.1.1:53", "1.0.0.1:53"]
            }
          }
        }
      }

      providers = {
        consulCatalog = {
          endpoint = {
            address = data.tfe_outputs.consul.values.connections.leader.address
            token   = data.consul_acl_token_secret_id.this.secret_id
          }
          exposedByDefault = false
          constraints      = "Tag(`traefik.enable=true`)"
        }
        file = {
          filename = "/etc/traefik/dynamic_config.yaml"
          watch    = true
        }
      }
    }
    dynamic_config = {
      http = {
        routers = {
          wildcard_infra = {
            rule        = "Host(`_wildcard.infra.the-lab.zone`)"
            service     = "noop@internal"
            priority    = 1
            entryPoints = ["websecure"]
            tls = {
              certResolver = "cloudflare"
              domains = [
                {
                  main = "infra.the-lab.zone"
                  sans = ["*.infra.the-lab.zone"]
                }
              ]
            }
          }

          wildcard_tooling = {
            rule        = "Host(`_wildcard.tooling.the-lab.zone`)"
            service     = "noop@internal"
            priority    = 1
            entryPoints = ["websecure"]
            tls = {
              certResolver = "cloudflare"
              domains = [
                {
                  main = "tooling.the-lab.zone"
                  sans = ["*.tooling.the-lab.zone"]
                }
              ]
            }
          }

          wildcard_root = {
            rule        = "Host(`_wildcard.the-lab.zone`)"
            service     = "noop@internal"
            priority    = 1
            entryPoints = ["websecure"]
            tls = {
              certResolver = "cloudflare"
              domains = [
                {
                  main = "the-lab.zone"
                  sans = ["*.the-lab.zone"]
                }
              ]
            }
          }

          proxmox = {
            rule        = "Host(`proxmox.infra.the-lab.zone`)"
            service     = "proxmox"
            entryPoints = ["websecure"]
            tls         = {}
          }

          truenas = {
            rule        = "Host(`nas.infra.the-lab.zone`)"
            service     = "truenas"
            entryPoints = ["websecure"]
            tls         = {}
          }


          unifi = {
            rule        = "Host(`unifi.infra.the-lab.zone`)"
            service     = "unifi"
            entryPoints = ["websecure"]
            tls         = {}
          }

          consul = {
            rule        = "Host(`consul.infra.the-lab.zone`)"
            service     = "consul"
            entryPoints = ["websecure"]
            tls         = {}
          }

          vault = {
            rule        = "Host(`vault.infra.the-lab.zone`)"
            service     = "vault"
            entryPoints = ["websecure"]
            tls         = {}
          }
        }

        services = {
          proxmox = {
            loadBalancer = {
              servers = [
                { url = "https://192.168.40.200:8006" }
              ]
              serversTransport = "insecureTransport"
            }
          }

          truenas = {
            loadBalancer = {
              servers = [
                { url = "https://192.168.40.4" }
              ]
              serversTransport = "insecureTransport"
            }
          }

          unifi = {
            loadBalancer = {
              servers = [
                { url = "https://192.168.40.1" }
              ]
              serversTransport = "insecureTransport"
            }
          }

          consul = {
            loadBalancer = {
              servers = [
                { url = "http://192.168.40.11:8500" },
                { url = "http://192.168.40.12:8500" },
                { url = "http://192.168.40.13:8500" },
              ]
              serversTransport = "insecureTransport"
            }
          }

          vault = {
            loadBalancer = {
              servers = [
                { url = "http://192.168.40.31:8200" },
                { url = "http://192.168.40.32:8200" },
                { url = "http://192.168.40.33:8200" },
              ]
              serversTransport = "insecureTransport"
            }
          }
        }

        serversTransports = {
          insecureTransport = {
            insecureSkipVerify = true
          }
        }
      }
    }
  }

}
