terraform {
  required_version = ">= 1.0.0"
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.93.0"
    }
    consul = {
      source  = "hashicorp/consul"
      version = "2.23.0"
    }
    tfe = {
      version = "~> 0.73.0"
    }
  }
}
