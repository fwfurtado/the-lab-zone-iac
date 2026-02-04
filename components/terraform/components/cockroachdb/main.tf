module "this" {
  depends_on = [consul_acl_token.this]
  source     = "../../modules/lxc"

  for_each = { for server in var.cockroachdb.servers : server.id => server }

  proxmox_node_name    = var.proxmox_node_name
  proxmox_host         = var.proxmox_host
  proxmox_ssh_username = var.proxmox_ssh_username
  proxmox_ssh_agent    = var.proxmox_ssh_agent

  defaults = var.defaults

  container = merge(var.container,
    {
      id          = each.value.id,
      hostname    = each.value.hostname,
      description = each.value.description,
      network = {
        ip_cidr = each.value.ip_cidr,
      },

      entrypoint = "/cockroach/cockroach.sh start --insecure --http-addr=0.0.0.0:8080 --advertise-addr=${local.ips[each.value.id]} --join=${local.join_addresses} --cache=512MiB"
    }
  )
}



resource "null_resource" "initialize" {
  depends_on = [module.this]

  connection {
    type  = "ssh"
    user  = var.proxmox_ssh_username
    host  = var.proxmox_host
    agent = var.proxmox_ssh_agent
  }

  provisioner "remote-exec" {
    inline = [
      "sleep 10",
      "sudo pct exec ${var.cockroachdb.servers[0].id} -- cockroach init --insecure --host=localhost:26257 2>/dev/null || echo 'Cluster já inicializado'",
      "sudo pct exec ${var.cockroachdb.servers[0].id} -- cockroach sql --insecure -e \"SET CLUSTER SETTING enterprise.license = '${var.cockroachdb_enterprise_license}';\"",
      "sudo pct exec ${var.cockroachdb.servers[0].id} -- cockroach sql --insecure -e \"SET CLUSTER SETTING cluster.organization = '${var.cockroachdb_cluster_organization}';\"",
      "sudo pct exec ${var.cockroachdb.servers[0].id} -- cockroach node status --insecure",
    ]
  }
}