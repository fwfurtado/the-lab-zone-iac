module "this" {
  source = "../../modules/lxc"

  proxmox_node_name    = var.proxmox_node_name
  proxmox_host         = var.proxmox_host
  proxmox_ssh_username = var.proxmox_ssh_username
  proxmox_ssh_agent    = var.proxmox_ssh_agent

  defaults = var.defaults

  container = merge(var.container,
    {
      id          = var.tailscale.id,
      hostname    = var.tailscale.hostname,
      description = var.tailscale.description,
      entrypoint  = "/usr/local/bin/containerboot",
      network = {
        ip_cidr = var.tailscale.ip_cidr,
      },
      started = false,
      should_reboot = false,
      environment_variables = {
        TS_AUTHKEY   = nonsensitive(var.ts_authkey),
        TS_ROUTES    = join(",", var.tailscale.routes),
        TS_STATE_DIR = "/var/tailscale/data"
        TS_HOSTNAME  = "tailscale-node"
        PATH         = "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
      }
    }
  )
}


resource "null_resource" "this" {
  depends_on = [module.this]
  connection {
    type  = "ssh"
    user  = var.proxmox_ssh_username
    host  = var.proxmox_host
    agent = var.proxmox_ssh_agent
  }

  provisioner "remote-exec" {
    inline = [
      # Adiciona as permissões de TUN diretamente no .conf do container no Proxmox
      "echo 'lxc.cgroup2.devices.allow: c 10:200 rwm' | sudo tee -a /etc/pve/lxc/${var.tailscale.id}.conf",
      "echo 'lxc.mount.entry: /dev/net/tun dev/net/tun none bind,create=file' | sudo tee -a /etc/pve/lxc/${var.tailscale.id}.conf",
      "sudo pct reboot ${var.tailscale.id} --timeout 60",
    ]
  }
}
