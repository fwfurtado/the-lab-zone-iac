locals {
  server_config = {
    server = true,

    #   node_name        = "placeholder",
    datacenter = var.consul.datacenter,

    log_level = "info",
    log_json  = true,

    node_meta = {
      external_source = "proxmox",
    }
    telemetry = {
      prometheus_retention_time = "372h" # 15 days
      disable_hostname          = true
    }

    bootstrap_expect = length(var.consul.servers),
    data_dir         = var.consul.data_dir,
    bind_addr        = "0.0.0.0",
    client_addr      = "0.0.0.0",
    retry_join       = [for server in var.consul.servers : split("/", server.ip_cidr)[0]],
    ui_config        = { enabled = true }

    acl = {
      enabled                  = true
      default_policy           = "deny"
      enable_token_persistence = true
      down_policy              = "extend-cache"
    }
  }

  ems_config = {

    log_level = "debug"
    log_json  = true

    token = var.consul_esm_token

    consul_service     = "consul-esm"
    consul_service_tag = "esm"
    consul_kv_path     = "consul-esm/"

    external_node_meta = {
      external-node = "true"
    }

    node_reconnect_timeout = "72h"
    node_probe_interval    = "10s"

    http_addr        = "${split("/", var.consul.servers[0].ip_cidr)[0]}:8500"
    client_address   = "0.0.0.0:8080"
    datacenter       = var.consul.datacenter
    ping_type        = "udp"
    enable_agentless = true

    telemetry = {
      prometheus_retention_time = "372h" # 15 days
      disable_hostname          = true
    }
  }
}
