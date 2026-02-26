build {
  sources = ["source.lxc.base"]

  provisioner "shell" {
    inline = concat(
      [
        "apt-get update",
        "apt-get install -y ansible",
      ],
      local.extra_packages_cmd
    )
    environment_vars = ["DEBIAN_FRONTEND=noninteractive"]
  }

  provisioner "ansible-local" {
    playbook_file   = var.playbook_file
    extra_arguments = local.extra_vars_args
  }

  provisioner "shell" {
    inline = [
      "apt-get purge -y ansible",
      "apt-get autoremove -y",
      "apt-get clean",
      "rm -rf /var/lib/apt/lists/*",
      "find /var/log -type f -exec truncate -s 0 {} \\;",
      "rm -f /root/.bash_history",
      "truncate -s 0 /etc/machine-id",
      "rm -f /etc/ssh/ssh_host_*",
    ]
    environment_vars = ["DEBIAN_FRONTEND=noninteractive"]
  }

  post-processor "shell-local" {
    inline = [
      "set -e",
      "OUTPUT_DIR=\"$(pwd)/${var.output_dir}\"",
      "WORK_DIR=$(mktemp -d)",
      "tar xzf \"$OUTPUT_DIR/rootfs.tar.gz\" --strip-components=2 -C \"$WORK_DIR\"",
      "rm -rf \"$WORK_DIR/dev\" && mkdir -p \"$WORK_DIR/dev\"",
      "tar czf \"$OUTPUT_DIR/${local.template_filename}\" -C \"$WORK_DIR\" .",
      "rm -f \"$OUTPUT_DIR/rootfs.tar.gz\"",
      "rm -rf \"$WORK_DIR\"",
      "echo \">>> Template pronto: $OUTPUT_DIR/${local.template_filename}\"",
    ]
  }
}