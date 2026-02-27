variable "app_name" {
  type        = string
  description = "Nome da aplicação"
}

variable "distro" {
  type    = string
  default = "debian"
}

variable "release" {
  type    = string
  default = "bookworm"
}

variable "arch" {
  type    = string
  default = "amd64"
}

variable "output_dir" {
  type    = string
  default = "output"
}

variable "playbook_file" {
  type        = string
  description = "Caminho para o playbook Ansible"
}

variable "ansible_extra_vars" {
  type    = map(string)
  default = {}
}

variable "extra_packages" {
  type    = list(string)
  default = []
}

variable "files" {
  type = map(object({
    content = string
    args    = map(string)
  }))
  default     = {}
  description = "Arquivos a criar no container: key = path destino"
}