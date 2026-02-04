resource "consul_node" "this" {
  depends_on = [module.this]
  for_each   = { for server in var.garage.servers : server.id => server }

  name    = each.value.hostname
  address = each.value.ip_address

  meta = {
    "external-node" = "true"
    "stack"         = "databases"
    "managed-by"    = "terraform"
  }
}

resource "consul_service" "garage" {
  depends_on = [consul_node.this]
  for_each   = { for server in var.garage.servers : server.id => server }

  name    = "garage"
  node    = each.value.hostname
  address = each.value.ip_address
  port    = 26257

  tags = [
    "v25.4.3",
    each.key == "1" ? "primary" : "secondary",
    "traefik.enable=true",
    "traefik.http.routers.cockroachdb.rule=Host(`cockroach.infra.the-lab.zone`)",
    "traefik.http.routers.cockroachdb.entrypoints=websecure",
    "traefik.http.routers.cockroachdb.tls=true",
    "traefik.http.services.cockroachdb.loadBalancer.server.port=8080",

    "traefik.tcp.routers.cockroachdb-sql.rule=HostSNI(`*`)",
    "traefik.tcp.routers.cockroachdb-sql.entrypoints=cockroachdb-sql-tls",
    "traefik.tcp.services.cockroachdb-sql.loadBalancer.server.port=26257",
    "traefik.tcp.routers.cockroachdb-sql.service=cockroachdb-sql",
  ]

  check {
    check_id                          = "cockroach-health-${each.key}"
    name                              = "CockroachDB Health Check"
    tcp                               = "${each.value.ip_address}:26257"
    interval                          = "10s"
    timeout                           = "5s"
    deregister_critical_service_after = "1m0s"
  }

  lifecycle {
    ignore_changes = [
      check
    ]
  }
}
