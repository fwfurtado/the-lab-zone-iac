resource "null_resource" "override_entrypoint" {
  depends_on = [proxmox_virtual_environment_container.this]


  triggers = {
    entrypoint = sha256(local.container.entrypoint)
  }

  connection {
    type  = "ssh"
    user  = local.proxmox.ssh.username
    host  = local.proxmox.ssh.host
    agent = local.proxmox.ssh.agent
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Setting entrypoint to ${local.container.entrypoint}' ",
      "timeout 10s bash -c 'sudo pct set ${local.container.id} --entrypoint \"${local.container.entrypoint}\"'",
      "echo 'Entrypoint set to ${local.container.entrypoint}'",
    ]
  }
}
