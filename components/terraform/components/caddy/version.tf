terraform {
  required_version = ">= 1.0.0"
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.6.2"
    }
    truenas = {
      source  = "deevus/truenas"
      version = "~> 0.1"
    }
  }
}
