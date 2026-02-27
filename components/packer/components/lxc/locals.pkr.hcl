locals {
  playbook_file = abspath("${path.root}/../../../../stacks/catalog/packer/${var.app_name}/playbook.yml")

  extra_vars_args = length(var.ansible_extra_vars) > 0 ? [
    "--extra-vars",
    join(" ", [for k, v in var.ansible_extra_vars : "${k}=${v}"])
  ] : []

  resolved_files = { for dest, file in var.files : dest => {
    content = file(abspath("${path.root}/../../../../${file.source}"))
    args    = file.args
  }}

  packer_files_base64 = base64encode(jsonencode({ packer_files = local.resolved_files }))

  write_vars_file_cmds = length(var.files) > 0 ? [
    "echo '${local.packer_files_base64}' | base64 -d > /tmp/packer-files.json",
  ] : []

  extra_packages_cmd = length(var.extra_packages) > 0 ? [
    "apt-get install -y ${join(" ", var.extra_packages)}"
  ] : []

  write_env_vars_cmds = [for k, v in var.environment_variables : "echo '${k}=${v}' >> /etc/environment"]

  template_filename = "${var.app_name}-${var.distro}-${replace(var.release, ".", "")}-template.tar.gz"
}
