export PROXMOX_VE_API_TOKEN={{ op://homelab/Proxmox Terraform Token/username }}={{ op://homelab/Proxmox Terraform Token/password }}
export PROXMOX_VE_ENDPOINT={{ op://homelab/Proxmox Terraform ssh/admin console/admin console URL }}
export PROXMOX_VE_INSECURE=true
export PROXMOX_VE_SSH_USERNAME={{ op://homelab/Proxmox Terraform ssh/username }}
export PROXMOX_VE_SSH_AGENT=true

export PROXMOX_SSH_NODE_NAME=pve
export PROXMOX_SSH_HOST={{ op://homelab/Proxmox Terraform ssh/URL}}
export PROXMOX_SSH_USERNAME={{ op://homelab/Proxmox Terraform ssh/username }}
export PROXMOX_SSH_AGENT=true

export TF_TOKEN_app_terraform_io={{ op://development/Terraform/api token/homelab-cli }}

export TS_AUTHKEY={{ op://homelab/Tailscale Infra Key/credential }}

export CLOUDFLARE_API_KEY={{ op://development/Cloudflare/the-lab.zone }}

export ZOT_IMAGE_REGISTRY_USERNAME={{ op://homelab/Zot K8s/username}}
export ZOT_IMAGE_REGISTRY_PASSWORD={{ op://homelab/Zot K8s/password}}


export GARAGE_CADDY_ACCESS_KEY={{ op://homelab/Caddy Garage S3/access-key-id}}
export GARAGE_CADDY_SECRET_KEY={{ op://homelab/Caddy Garage S3/secret-access-key}}

export TECHNITIUM_ADMIN_PASSWORD={{ op://homelab/Technitium Admin/password }}


export TRUENAS_SSH_HOST={{ op://homelab/TrueNAS root Ssh Key/host}}
export TRUENAS_SSH_PORT=2223
export TRUENAS_SSH_USERNAME={{ op://homelab/TrueNAS root Ssh Key/username}}
export TRUENAS_SSH_PRIVATE_KEY="{{ op://homelab/TrueNAS root Ssh Key/private key?ssh-format=openssh}}"
export TRUENAS_SSH_HOST_KEY_FINGERPRINT={{ op://homelab/TrueNAS root Ssh Key/host-fingerprints/ECDSA}}
