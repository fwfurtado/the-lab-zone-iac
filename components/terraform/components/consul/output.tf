output "server" {
  value = module.consul-cluster
}

output "esm" {
  value = module.consul-esm
}

output "connections" {
  value = {
    leader = {
      ip = split("/", var.consul.servers[0].ip_cidr)[0],
      port = 8500
      address = "${split("/", var.consul.servers[0].ip_cidr)[0]}:8500"
      endpoint = "http://${split("/", var.consul.servers[0].ip_cidr)[0]}:8500"
    }
  }
}