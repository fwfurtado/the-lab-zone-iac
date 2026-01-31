resource "null_resource" "envs" {
  depends_on = [proxmox_virtual_environment_container.this]
  count = length(local.container.environment_variables) > 0 ? 1 : 0

  triggers = {
    environment_variables = sha256(jsonencode(local.container.environment_variables))
  }

  connection {
    type  = "ssh"
    user  = local.proxmox.ssh.username
    host  = local.proxmox.ssh.host
    agent = local.proxmox.ssh.agent
  }


  provisioner "remote-exec" {
    inline = [for key, value in local.container.environment_variables : "timeout 5s bash -c \"echo 'lxc.environment.runtime: ${key}=${value}' | sudo tee -a /etc/pve/lxc/${local.container.id}.conf \""]
  }
}
