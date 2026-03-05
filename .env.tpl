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

export CLOUDFLARE_API_KEY={{ op://development/Cloudflare/the-lab.zone }}

export ZOT_IMAGE_REGISTRY_USERNAME={{ op://homelab/Zot K8s/username}}
export ZOT_IMAGE_REGISTRY_PASSWORD={{ op://homelab/Zot K8s/password}}


export GARAGE_RPC_SECRET={{ op://homelab/Garage RPC Secret/secret }}
export GARAGE_ADMIN_TOKEN={{ op://homelab/Garage Admin Token/credential }}

# <run: ssh root@10.40.1.11 "GARAGE_CONFIG_FILE=/etc/garage/garage.toml garage node id" | cut -c1-64>
export GARAGE_NODE_ID="d2729bbe8bd1d6a3cd1c5ddd85362cb545579cc6aa78ed9045b898413e6543ee"

export GARAGE_CADDY_ACCESS_KEY={{ op://homelab/Caddy Garage S3/access-key-id}}
export GARAGE_CADDY_SECRET_KEY={{ op://homelab/Caddy Garage S3/secret-access-key}}


export AUTHELIA_JWT_SECRET={{ op://homelab/Authelia/jwt_secret }}
export AUTHELIA_SESSION_SECRET={{ op://homelab/Authelia/session_secret }}
export AUTHELIA_STORAGE_ENCRYPTION_KEY={{ op://homelab/Authelia/storage_encryption_key }}

export POSTGRES_MAJOR_VERSION=18
export POSTGRES_ADMIN_PASSWORD={{ op://homelab/PostgreSQL Admin/password }}

export VALKEY_PASSWORD={{ op://homelab/Valkey/password }}

export STEP_CA_PASSWORD={{ op://homelab/Step CA/password }}
export STEP_CA_URL=https://step-ca.infra.the-lab.zone:8443
export STEP_CA_FINGERPRINT={{ op://homelab/Step CA/fingerprint }}


export GITEA_DB_PASSWORD={{ op://homelab/Gitea Database/password }}
export FORGEJO_DB_PASSWORD={{ op://homelab/Forgejo Database/password }}

export SSH_PUBLIC_KEY="{{ op://homelab/SSH Key Proxmox fwfurtado/public key }}"

export FORGEJO_ADMIN_USERNAME={{ op://homelab/Forgejo Admin/username }}
export FORGEJO_ADMIN_PASSWORD={{ op://homelab/Forgejo Admin/password }}
export FORGEJO_ADMIN_EMAIL={{ op://homelab/Forgejo Admin/email }}
