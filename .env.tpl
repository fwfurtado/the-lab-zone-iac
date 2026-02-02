export PROXMOX_VE_API_TOKEN={{ op://homelab/Proxmox Terraform Token/username }}={{ op://homelab/Proxmox Terraform Token/password }}
export PROXMOX_VE_ENDPOINT={{ op://homelab/Proxmox Terraform ssh/admin console/admin console URL }}
export PROXMOX_VE_INSECURE=true
export PROXMOX_VE_SSH_USERNAME={{ op://homelab/Proxmox Terraform ssh/username }}
export PROXMOX_VE_SSH_AGENT=true
export TF_VAR_proxmox_node_name=proxmox
export TF_VAR_proxmox_host={{ op://homelab/Proxmox Terraform ssh/URL}}
export TF_VAR_proxmox_ssh_username={{ op://homelab/Proxmox Terraform ssh/username }}
export TF_VAR_proxmox_ssh_agent=true

export TF_TOKEN_app_terraform_io={{ op://development/Terraform/api token/homelab-cli }}

export TF_VAR_consul_esm_token={{ op://homelab/Consul Server/acl esm/secret-id }}

export CONSUL_HTTP_ADDR={{ op://homelab/Consul Server/address }}
export CONSUL_HTTP_SSL=false
export CONSUL_HTTP_TOKEN={{ op://homelab/Consul Server/acl management/secret-id }}