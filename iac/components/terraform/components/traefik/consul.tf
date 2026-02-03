resource "consul_node" "this" {
  depends_on = [module.this]

  name    = var.traefik.hostname
  address = split("/", var.traefik.ip_cidr)[0]

  meta = {
    "external-node" = "true"
    "stack"         = "proxies"
    "managed-by"    = "terraform"
  }
}

resource "consul_service" "this" {
  depends_on = [consul_node.this]

  name    = "traefik"
  node    = var.traefik.hostname
  address = split("/", var.traefik.ip_cidr)[0]
  port    = 8080

  tags = [
    "v3.0",
    "traefik.enable=true",
    "traefik.http.routers.traefik.rule=Host(`traefik.infra.the-lab.zone`)",
    "traefik.http.routers.traefik.tls=true",
    "traefik.http.routers.traefik.entrypoints=websecure",

  ]

  check {
    check_id                          = "traefik-health"
    name                              = "Traefik Health Check"
    http                              = "http://${split("/", var.traefik.ip_cidr)[0]}:8080/ping"
    interval                          = "10s"
    timeout                           = "5s"
    deregister_critical_service_after = "5m0s"
  }

  lifecycle {
    ignore_changes = [
      check
    ]
  }
}
