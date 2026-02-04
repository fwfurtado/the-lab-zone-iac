resource "null_resource" "files" {
  depends_on = [proxmox_virtual_environment_container.this]
  for_each   = nonsensitive(local.container.files)

  triggers = {
    files = sha256(jsonencode(local.container.files))
  }

  connection {
    type  = "ssh"
    user  = local.proxmox.ssh.username
    host  = local.proxmox.ssh.host
    agent = local.proxmox.ssh.agent
  }

  provisioner "file" {
    content     = each.value
    destination = "/tmp/${local.container.id}-${basename(each.key)}"
  }

  provisioner "remote-exec" {
    inline = [
      "timeout 1m bash -c 'until sudo pct status ${local.container.id} | grep -iq running; do echo \"Waiting for container to start...\"; sleep 5; done' || { echo \"Timeout exceeded: Container '${local.container.hostname}' failed to start\" >&2; exit 1; }",
      "timeout 10s sudo pct exec ${local.container.id} -- mkdir -p ${dirname(each.key)}",
      "timeout 20s sudo pct push ${local.container.id} /tmp/${local.container.id}-${basename(each.key)} ${each.key}"
    ]
  }
}
