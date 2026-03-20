export PROXMOX_VE_API_TOKEN={{ op://homelab/Proxmox Terraform Token/username }}={{ op://homelab/Proxmox Terraform Token/password }}
export PROXMOX_VE_ENDPOINT={{ op://homelab/Proxmox Terraform ssh/admin console/admin console URL }}
export PROXMOX_VE_INSECURE=true
export PROXMOX_VE_SSH_USERNAME={{ op://homelab/Proxmox Terraform ssh/username }}
export PROXMOX_VE_SSH_AGENT=true

export PROXMOX_SSH_NODE_NAME=pve
export PROXMOX_SSH_HOST={{ op://homelab/Proxmox Terraform ssh/URL}}
export PROXMOX_SSH_USERNAME=fwfurtado
export PROXMOX_SSH_AGENT=true

export TF_TOKEN_app_terraform_io={{ op://development/Terraform/api token/homelab-cli }}

export TS_AUTH_KEY={{ op://homelab/Tailscale Infra Key/credential }}

export SSH_PUBLIC_KEY="{{ op://homelab/SSH Key Proxmox fwfurtado/public key }}"
