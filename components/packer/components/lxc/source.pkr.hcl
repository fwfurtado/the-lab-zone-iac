source "lxc" "base" {
  config_file   = "${path.root}/config/lxc.conf"
  template_name = var.distro

  template_parameters = [
    "--arch", var.arch,
    "--release", var.release,
  ]

  template_environment_vars = [
    "MIRROR=http://deb.debian.org/debian/",
    "SUITE=${var.release}",
  ]

  init_timeout     = "60s"
  target_runlevel  = 3
  output_directory = var.output_dir
  container_name   = "packer-${var.app_name}"
}
