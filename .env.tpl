export PROXMOX_VE_API_TOKEN={{ op://homelab/Proxmox Terraform Token/username }}={{ op://homelab/Proxmox Terraform Token/password }}
export PROXMOX_VE_ENDPOINT={{ op://homelab/Proxmox Terraform ssh/admin console/admin console URL }}
export PROXMOX_VE_INSECURE=true
export PROXMOX_VE_SSH_USERNAME={{ op://homelab/Proxmox Terraform ssh/username }}
export PROXMOX_VE_SSH_AGENT=true

export TF_VAR_proxmox_node_name=proxmox
export TF_VAR_proxmox_host={{ op://homelab/Proxmox Terraform ssh/URL}}
export TF_VAR_proxmox_ssh_username={{ op://homelab/Proxmox Terraform ssh/username }}
export TF_VAR_proxmox_ssh_agent=true

export TF_TOKEN_app_terraform_io={{ op://development/Terraform/api token/the-lab-zone-org-token }}

export TF_VAR_ts_authkey={{ op://development/Tailscale/Auth Key }}

export TF_VAR_cloudflare_api_key={{ op://development/Cloudflare/the-lab.zone }}