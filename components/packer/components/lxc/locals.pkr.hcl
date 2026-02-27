locals {
  # Passa os arquivos (content + args) para o Ansible renderizar com o módulo template
  ansible_files_var = length(var.files) > 0 ? [
    "--extra-vars",
    jsonencode({ packer_files = var.files })
  ] : []

  extra_vars_args = concat(
    length(var.ansible_extra_vars) > 0 ? [
      "--extra-vars",
      join(" ", [for k, v in var.ansible_extra_vars : "${k}=${v}"])
    ] : [],
    local.ansible_files_var
  )

  extra_packages_cmd = length(var.extra_packages) > 0 ? [
    "apt-get install -y ${join(" ", var.extra_packages)}"
  ] : []

  template_filename = "${var.app_name}-${var.distro}${replace(var.release, ".", "")}-template.tar.gz"
}