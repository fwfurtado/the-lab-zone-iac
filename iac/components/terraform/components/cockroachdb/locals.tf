locals {
  join_addresses = join(",", [for server in var.cockroachdb.servers : split("/", server.ip_cidr)[0]])
}
