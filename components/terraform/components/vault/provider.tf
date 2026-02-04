provider "proxmox" {
    // All values are loaded from the .env file
}

provider "consul" {
  datacenter = var.consul_datacenter
   // All other values are loaded from the .env file
}

provider "tfe" {
    // All values are loaded from the .env file
}