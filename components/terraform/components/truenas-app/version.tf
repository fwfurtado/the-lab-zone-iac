terraform {
  required_version = ">= 1.0.0"
  required_providers {
    truenas = {
      source  = "deevus/truenas"
      version = "~> 0.14.0"
    }
  }
}
