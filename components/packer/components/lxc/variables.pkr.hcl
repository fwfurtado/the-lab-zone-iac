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

variable "ansible_extra_vars" {
  type    = map(string)
  default = {}
}

variable "extra_packages" {
  type    = list(string)
  default = []
}

variable "environment_variables" {
  type        = map(string)
  default     = {}
  description = "Variáveis de ambiente a persistir em /etc/environment no container"
}

variable "files" {
  type = map(object({
    source = string
    args   = map(string)
  }))
  default     = {}
  description = "Arquivos a criar no container: key = path destino, source = caminho local do arquivo"
}
