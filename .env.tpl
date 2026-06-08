export PROXMOX_VE_API_TOKEN={{ op://homelab/Proxmox Terraform Token/username }}={{ op://homelab/Proxmox Terraform Token/password }}
export PROXMOX_VE_ENDPOINT={{ op://homelab/Proxmox Terraform ssh/admin console/admin console URL }}
export PROXMOX_VE_INSECURE=true
export PROXMOX_VE_SSH_USERNAME=root
export PROXMOX_VE_SSH_AGENT=true
export PROXMOX_VE_SSH_NODE_ADDRESS={{ op://homelab/Proxmox Terraform ssh/URL}}


export PROXMOX_SSH_NODE_NAME=pve
export PROXMOX_SSH_HOST={{ op://homelab/Proxmox Terraform ssh/URL}}
export PROXMOX_SSH_USERNAME=root
export PROXMOX_SSH_AGENT=true

export TF_TOKEN_app_terraform_io={{ op://development/Terraform/api token/homelab-cli }}

export TS_AUTH_KEY={{ op://homelab/Tailscale Infra Key/credential }}

export SSH_PUBLIC_KEY="{{ op://homelab/SSH Key Proxmox fwfurtado/public key }}"

# Patroni PostgreSQL
export PATRONI_SUPERUSER_PASSWORD={{ op://homelab/Patroni PostgreSQL/superuser-password }}
export PATRONI_REPLICATION_PASSWORD={{ op://homelab/Patroni PostgreSQL/replication-password }}
export PGBACKREST_S3_KEY={{ op://homelab/MinIO PgBackRest/access-key }}
export PGBACKREST_S3_SECRET={{ op://homelab/MinIO PgBackRest/secret-key }}
export PGBACKREST_REPO_CIPHER_PASS={{ op://homelab/PgBackRest Encryption/cipher-pass }}
export PG_AUTHELIA_PASSWORD={{ op://homelab/Authelia Database/password }}
export PG_CODER_PASSWORD={{ op://homelab/Coder Database/password }}
export PG_FORGEJO_PASSWORD={{ op://homelab/Forgejo Database/password }}
export PG_INFISICAL_PASSWORD={{ op://homelab/Infisical Database/password }}
export PG_LITELLM_PASSWORD={{ op://homelab/LiteLLM Database/password }}
export PG_CONTEXT_FORGE_PASSWORD={{ op://homelab/Context Forge AI Database/password }}
export PG_OBOT_PASSWORD={{ op://homelab/Obot Database/password }}
export PG_TOOLHIVE_REGISTRY_PASSWORD={{ op://homelab/ToolHive Registry Database/password }}

# MinIO AIStor
export MINIO_ROOT_USER={{ op://homelab/MinIO AIStor/username }}
export MINIO_ROOT_PASSWORD={{ op://homelab/MinIO AIStor/password }}
export MINIO_LICENSE={{ op://homelab/MinIO AIStor/minio.license }}
