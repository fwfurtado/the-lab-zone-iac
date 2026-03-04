---
name: Execution plan migration
overview: Plano de execucao passo-a-passo para migrar todas as 9 stacks de Packer para Terraform lxc-v2 + Ansible, com backup/restore dos containers stateful e destruicao dos antigos via Terraform Cloud + pct.
todos:
  - id: fase0-prep
    content: "Fase 0: Preparacao -- carregar .env, criar diretorio de backup no Proxmox"
    status: pending
  - id: fase1-step-ca
    content: "Fase 1: Migrar step-ca -- backup /var/lib/step-ca, destroy, apply, configure, restore"
    status: pending
  - id: fase2-coredns
    content: "Fase 2: Migrar coredns -- destroy, apply, configure, validar DNS"
    status: pending
  - id: fase3-stateless
    content: "Fase 3: Migrar tailscale + authelia + zot (stateless, sem backup)"
    status: pending
  - id: fase4-postgresql
    content: "Fase 4.1: Migrar postgresql -- pg_dumpall, destroy, apply, configure, restore"
    status: pending
  - id: fase4-garage
    content: "Fase 4.2: Migrar garage -- backup /var/lib/garage, destroy, apply, configure, restore"
    status: pending
  - id: fase5-gitea
    content: "Fase 5: Migrar gitea -- backup /var/lib/gitea, destroy, apply, configure, deploy-config, restore"
    status: pending
  - id: fase6-caddy
    content: "Fase 6: Migrar caddy -- destroy, apply, configure, deploy-config"
    status: pending
  - id: fase7-cleanup
    content: "Fase 7: Limpeza -- deletar workspaces antigos, rodar drift em tudo, limpar backups"
    status: pending
isProject: false
---

# Plano de Execucao: Migracao Completa para lxc-v2

## Classificacao dos containers

### Stateful (COM mount_points -- requerem backup/restore)

- **step-ca** (CT 103) -- `/var/lib/step-ca` (10G) -- CA keys, CRITICO
- **postgresql** (CT 141) -- `/var/lib/postgresql/data` (100G) -- banco de dados
- **garage** (CT 110) -- `/var/lib/garage/data` (100G) -- S3 storage
- **gitea** (CT 120) -- `/var/lib/gitea` (50G) -- git repos

### Stateless (SEM dados persistentes -- nao requerem backup)

- **tailscale** (CT 100) -- re-autentica com auth key
- **coredns** (CT 102) -- config vem do Ansible
- **authelia** (CT 104) -- config via deploy-config
- **caddy** (CT 121) -- config via deploy-config
- **zot** (CT 130) -- imagens OCI podem ser re-pushed

## Procedimento padrao para cada container

Backup nos containers antigos via `pct` (nao tem SSH). Restore nos containers novos via SSH (lxc-v2 injeta chaves SSH).

### Container stateful (com backup)

```
1. pct exec <ID> -- backup dos dados (tar/dump)       [container antigo, via pct]
2. pct pull <ID> -- copiar backup para host Proxmox    [container antigo, via pct]
3. pct stop <ID>
4. pct destroy <ID>
5. Deletar workspace antigo no Terraform Cloud
6. atmos workflow <app>/apply
7. atmos workflow <app>/configure
8. scp backup para novo container                      [container novo, via SSH]
9. ssh -- restaurar dados + reiniciar servico           [container novo, via SSH]
```

### Container stateless (sem backup)

```
1. pct stop <ID>
2. pct destroy <ID>
3. Deletar workspace antigo no Terraform Cloud
4. atmos workflow <app>/apply
5. atmos workflow <app>/configure
```

---

## Fase 0 -- Preparacao

```fish
# Garantir que o .env esta carregado
op inject -i .env.tpl | source

# Criar diretorio de backup no host Proxmox
ssh $PROXMOX_SSH_USERNAME@$PROXMOX_SSH_HOST "mkdir -p /tmp/migration-backups"
```

---

## Fase 1 -- step-ca (CT 103)

**RISCO ALTO** -- Enquanto o step-ca estiver offline, nenhum container renova certificados. Fazer o mais rapido possivel.

### 1.1 Backup

```fish
# Criar backup dentro do container
ssh $PROXMOX_SSH_USERNAME@$PROXMOX_SSH_HOST "sudo pct exec 103 -- tar czf /tmp/step-ca-backup.tar.gz -C / var/lib/step-ca"

# Extrair backup do container para o host Proxmox
ssh $PROXMOX_SSH_USERNAME@$PROXMOX_SSH_HOST "sudo pct pull 103 /tmp/step-ca-backup.tar.gz /tmp/migration-backups/step-ca-backup.tar.gz"
```

### 1.2 Destruir container antigo

```fish
ssh $PROXMOX_SSH_USERNAME@$PROXMOX_SSH_HOST "sudo pct stop 103 && sudo pct destroy 103"
```

- Ir ao Terraform Cloud e deletar o workspace `step-ca` do componente `lxc`

### 1.3 Criar novo containrer e configurar

```fish
atmos workflow step-ca/apply
atmos workflow step-ca/configure
```

### 1.4 Restaurar dados da CA

```fish
# Copiar backup do host Proxmox para o novo container via SSH
scp $PROXMOX_SSH_USERNAME@$PROXMOX_SSH_HOST:/tmp/migration-backups/step-ca-backup.tar.gz /tmp/step-ca-backup.tar.gz
scp /tmp/step-ca-backup.tar.gz root@10.40.1.3:/tmp/

# Parar servico, restaurar dados, corrigir permissoes, reiniciar
ssh root@10.40.1.3 "systemctl stop step-ca && tar xzf /tmp/step-ca-backup.tar.gz -C / && chown -R step-ca:step-ca /var/lib/step-ca && systemctl start step-ca && rm /tmp/step-ca-backup.tar.gz"
```

### 1.5 Validacao

```fish
curl -k https://step-ca.infra.the-lab.zone:8443/health
```

---

## Fase 2 -- coredns (CT 102)

**RISCO ALTO** -- Enquanto offline, DNS interno nao funciona. ACME challenges de outros containers falham.

### 2.1 Destruir (stateless, sem backup)

```fish
ssh $PROXMOX_SSH_USERNAME@$PROXMOX_SSH_HOST "sudo pct stop 102 && sudo pct destroy 102"
```

- Deletar workspace `coredns` (componente `lxc`) no Terraform Cloud

### 2.2 Criar e configurar

```fish
atmos workflow coredns/apply
atmos workflow coredns/configure
```

### 2.3 Validacao

```fish
dig @10.40.1.2 step-ca.infra.the-lab.zone
dig @10.40.1.2 valkey.infra.the-lab.zone
```

---

## Fase 3 -- Containers stateless independentes

Estes podem ser migrados em qualquer ordem. Nao precisam de backup.

### 3.1 tailscale (CT 100)

```fish
ssh $PROXMOX_SSH_USERNAME@$PROXMOX_SSH_HOST "sudo pct stop 100 && sudo pct destroy 100"
# Deletar workspace 'tailscale' (componente 'lxc') no Terraform Cloud
atmos workflow tailscale/apply
atmos workflow tailscale/configure
```

**Nota:** Voce perde acesso VPN durante a migracao. Faca a partir de acesso local/direto ao Proxmox.

### 3.2 authelia (CT 104)

```fish
ssh $PROXMOX_SSH_USERNAME@$PROXMOX_SSH_HOST "sudo pct stop 104 && sudo pct destroy 104"
# Deletar workspace 'authelia' (componente 'lxc') no Terraform Cloud
atmos workflow authelia/apply
atmos workflow authelia/configure
atmos workflow authelia/deploy-config
```

### 3.3 zot (CT 130)

```fish
ssh $PROXMOX_SSH_USERNAME@$PROXMOX_SSH_HOST "sudo pct stop 130 && sudo pct destroy 130"
# Deletar workspace 'zot' (componente 'lxc') no Terraform Cloud
atmos workflow zot/apply
atmos workflow zot/configure
```

**Nota:** Sem backup. Imagens OCI precisam ser re-pushed depois.

---

## Fase 4 -- Containers stateful independentes

### 4.1 postgresql (CT 141)

```fish
# Backup via pg_dumpall dentro do container
ssh $PROXMOX_SSH_USERNAME@$PROXMOX_SSH_HOST "sudo pct exec 141 -- runuser -u postgres -- pg_dumpall > /tmp/pg_dumpall.sql"
ssh $PROXMOX_SSH_USERNAME@$PROXMOX_SSH_HOST "sudo pct pull 141 /tmp/pg_dumpall.sql /tmp/migration-backups/pg_dumpall.sql"

# Destruir
ssh $PROXMOX_SSH_USERNAME@$PROXMOX_SSH_HOST "sudo pct stop 141 && sudo pct destroy 141"
# Deletar workspace 'postgresql' (componente 'lxc') no Terraform Cloud

# Criar e configurar
atmos workflow postgresql/apply
atmos workflow postgresql/configure

# Restaurar via SSH no novo container
scp $PROXMOX_SSH_USERNAME@$PROXMOX_SSH_HOST:/tmp/migration-backups/pg_dumpall.sql /tmp/pg_dumpall.sql
scp /tmp/pg_dumpall.sql root@10.40.1.41:/tmp/
ssh root@10.40.1.41 "runuser -u postgres -- psql -f /tmp/pg_dumpall.sql && rm /tmp/pg_dumpall.sql"
```

### 4.2 garage (CT 110)

```fish
# Backup dos dados (pode ser grande -- 100GB, considere usar vzdump como alternativa)
ssh $PROXMOX_SSH_USERNAME@$PROXMOX_SSH_HOST "sudo pct exec 110 -- tar czf /tmp/garage-backup.tar.gz -C / var/lib/garage"
ssh $PROXMOX_SSH_USERNAME@$PROXMOX_SSH_HOST "sudo pct pull 110 /tmp/garage-backup.tar.gz /tmp/migration-backups/garage-backup.tar.gz"

# Destruir
ssh $PROXMOX_SSH_USERNAME@$PROXMOX_SSH_HOST "sudo pct stop 110 && sudo pct destroy 110"
# Deletar workspace 'garage' (componente 'lxc') no Terraform Cloud

# Criar e configurar
atmos workflow garage/apply
atmos workflow garage/configure

# Restaurar dados e metadados via SSH no novo container
scp $PROXMOX_SSH_USERNAME@$PROXMOX_SSH_HOST:/tmp/migration-backups/garage-backup.tar.gz /tmp/garage-backup.tar.gz
scp /tmp/garage-backup.tar.gz root@10.40.1.10:/tmp/
ssh root@10.40.1.10 "systemctl stop garage && tar xzf /tmp/garage-backup.tar.gz -C / && chown -R garage:garage /var/lib/garage && systemctl start garage && rm /tmp/garage-backup.tar.gz"
```

---

## Fase 5 -- gitea (CT 120)

Depende de postgresql e garage ja migrados e funcionais.

```fish
# Backup
ssh $PROXMOX_SSH_USERNAME@$PROXMOX_SSH_HOST "sudo pct exec 120 -- tar czf /tmp/gitea-backup.tar.gz -C / var/lib/gitea"
ssh $PROXMOX_SSH_USERNAME@$PROXMOX_SSH_HOST "sudo pct pull 120 /tmp/gitea-backup.tar.gz /tmp/migration-backups/gitea-backup.tar.gz"

# Destruir
ssh $PROXMOX_SSH_USERNAME@$PROXMOX_SSH_HOST "sudo pct stop 120 && sudo pct destroy 120"
# Deletar workspace 'gitea-lxc' (componente 'lxc') no Terraform Cloud
# Nota: o workspace do gitea pode ter nome 'gitea-lxc' pois usa terraform_workspace: "{{ .stack }}-{{ .component }}"

# Criar e configurar
atmos workflow gitea/apply
atmos workflow gitea/configure
atmos workflow gitea/deploy-config

# Restaurar via SSH no novo container
scp $PROXMOX_SSH_USERNAME@$PROXMOX_SSH_HOST:/tmp/migration-backups/gitea-backup.tar.gz /tmp/gitea-backup.tar.gz
scp /tmp/gitea-backup.tar.gz root@10.40.1.20:/tmp/
ssh root@10.40.1.20 "systemctl stop gitea && tar xzf /tmp/gitea-backup.tar.gz -C / && chown -R git:git /var/lib/gitea && systemctl start gitea && rm /tmp/gitea-backup.tar.gz"
```

---

## Fase 6 -- caddy (CT 121)

Ultimo a migrar -- e o reverse proxy, entao todos os backends devem estar no ar antes.

```fish
ssh $PROXMOX_SSH_USERNAME@$PROXMOX_SSH_HOST "sudo pct stop 121 && sudo pct destroy 121"
# Deletar workspace 'caddy' (componente 'lxc') no Terraform Cloud
atmos workflow caddy/apply
atmos workflow caddy/configure
atmos workflow caddy/deploy-config
```

---

## Fase 7 -- Limpeza

- Deletar todos os workspaces antigos restantes do componente `lxc` no Terraform Cloud (se ainda existirem)
- Verificar que nao restam containers antigos no Proxmox
- Rodar drift em todos os containers para confirmar consistencia:

```fish
atmos workflow step-ca/drift
atmos workflow coredns/drift
atmos workflow tailscale/drift
atmos workflow postgresql/drift
atmos workflow garage/drift
atmos workflow authelia/drift
atmos workflow caddy/drift
atmos workflow zot/drift
atmos workflow gitea/drift
atmos workflow valkey/drift
```

- Limpar backups no host Proxmox:

```fish
ssh $PROXMOX_SSH_USERNAME@$PROXMOX_SSH_HOST "rm -rf /tmp/migration-backups/"
```

---

## Resumo de backups necessarios


| Container  | Mount Point                     | Backup (pct, container antigo)     | Restore (SSH, container novo) | Tamanho Estimado  |
| ---------- | ------------------------------- | ---------------------------------- | ----------------------------- | ----------------- |
| step-ca    | `/var/lib/step-ca`              | `pct exec` tar + `pct pull`        | `scp` + `ssh` tar xzf         | ~poucos MB        |
| postgresql | `/var/lib/postgresql/data`      | `pct exec` pg_dumpall + `pct pull` | `scp` + `ssh` psql -f         | depende dos dados |
| garage     | `/var/lib/garage` (data + meta) | `pct exec` tar + `pct pull`        | `scp` + `ssh` tar xzf         | ate 100GB         |
| gitea      | `/var/lib/gitea`                | `pct exec` tar + `pct pull`        | `scp` + `ssh` tar xzf         | ate 50GB          |


Containers SEM backup: tailscale, coredns, authelia, caddy, zot, valkey (ja migrado).

## Tempo estimado de downtime por servico

- **step-ca**: ~5-10 min (backup pequeno, restore rapido)
- **coredns**: ~3-5 min (stateless)
- **tailscale**: ~3-5 min (stateless, mas perde VPN)
- **postgresql**: ~10-30 min (depende do tamanho do dump)
- **garage**: ~30-120 min (depende do volume de dados S3)
- **gitea**: ~15-45 min (depende do volume de repos)
- **authelia/caddy/zot**: ~3-5 min cada (stateless)

