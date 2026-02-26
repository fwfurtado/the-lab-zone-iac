packer {
  required_plugins {
    lxc = {
      source  = "github.com/hashicorp/lxc"
      version = "~> 1"
    }

    ansible = {
      source  = "github.com/hashicorp/ansible"
      version = "~> 1"
    }
  }
}