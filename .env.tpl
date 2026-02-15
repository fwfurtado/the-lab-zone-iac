export PROXMOX_VE_API_TOKEN={{ op://homelab/Proxmox Terraform Token/username }}={{ op://homelab/Proxmox Terraform Token/password }}
export PROXMOX_VE_ENDPOINT={{ op://homelab/Proxmox Terraform ssh/admin console/admin console URL }}
export PROXMOX_VE_INSECURE=true
export PROXMOX_VE_SSH_USERNAME={{ op://homelab/Proxmox Terraform ssh/username }}
export PROXMOX_VE_SSH_AGENT=true

export PROXMOX_NODE_NAME=proxmox
export PROXMOX_SSH_HOST={{ op://homelab/Proxmox Terraform ssh/URL}}

export TF_TOKEN_app_terraform_io={{ op://development/Terraform/api token/homelab-cli }}

export TS_AUTHKEY={{ op://development/Tailscale/Auth Key }}

export CLOUDFLARE_API_KEY={{ op://development/Cloudflare/the-lab.zone }}

export ZOT_K8S_USERNAME={{ op://homelab/Zot K8s/username}}
export ZOT_K8S_PASSWORD={{ op://homelab/Zot K8s/password}}


export DOCKER_REGISTRY_ADDRESS={{ op://homelab/Zot Admin/url}}
export DOCKER_REGISTRY_USERNAME={{ op://homelab/Zot Admin/username}}
export DOCKER_REGISTRY_PASSWORD={{ op://homelab/Zot Admin/password}}
