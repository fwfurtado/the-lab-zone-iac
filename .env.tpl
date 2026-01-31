export PROXMOX_VE_API_TOKEN={{ op://homelab/Proxmox Terraform Token/username }}={{ op://homelab/Proxmox Terraform Token/password }}
export PROXMOX_VE_ENDPOINT={{ op://homelab/Proxmox Terraform ssh/admin console/admin console URL }}
export PROXMOX_VE_INSECURE=true
export PROXMOX_VE_SSH_USERNAME={{ op://homelab/Proxmox Terraform ssh/username }}
export PROXMOX_VE_SSH_AGENT=true
export TF_VAR_proxmox_node_name=proxmox
export TF_VAR_proxmox_host={{ op://homelab/Proxmox Terraform ssh/URL}}
export TF_VAR_proxmox_ssh_username={{ op://homelab/Proxmox Terraform ssh/username }}
export TF_VAR_proxmox_ssh_agent=true