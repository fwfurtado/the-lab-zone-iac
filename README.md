# The Lab Zone IaC

Infrastructure-as-code for the homelab: a Talos Kubernetes cluster and a Tailscale subnet router running on Proxmox, managed with [Atmos](https://atmos.tools) and Terraform.

Application workloads are deployed via GitOps in a separate repo ([the-lab-zone-gitops](https://github.com/fwfurtado/the-lab-zone-gitops)).

## Structure

| Path | Description |
|------|-------------|
| `atmos.yaml` | Atmos configuration |
| `components/terraform/modules/` | Reusable Terraform modules (`vm`, `lxc`) |
| `components/terraform/components/` | Atmos Terraform components (`talos-cluster`, `lxc`) |
| `stacks/` | Stack definitions (one per environment) |
| `stacks/catalog/` | Shared defaults (`_vm.yaml`, `_terraform-lxc.yaml`) |
| `workflows/` | Atmos workflows |
| `ansible/` | Ansible roles and playbooks for LXC configuration |

## Getting started

1. **Dependencies** -- install tools from `.tool-versions` (e.g. via asdf):
   - `atmos 1.205.0`

2. **Secrets** -- this project uses [1Password CLI](https://developer.1password.com/docs/cli/) to inject secrets. The `.envrc` runs `op inject` on `.env.tpl` automatically via direnv.

3. **Plan / apply**

   ```bash
   atmos terraform plan talos-cluster -s platform
   atmos terraform apply talos-cluster -s platform
   ```

## Stacks

| Stack | Component | Type | Description |
|-------|-----------|------|-------------|
| `platform` | `talos-cluster` | VM | Talos Kubernetes cluster (1 CP + 4 workers) |
| `tailscale` | `lxc` | LXC | Tailscale subnet router |

## Platform cluster

The `platform` stack provisions a 5-node Talos cluster as Proxmox VMs.

| Node | VM ID | Role | CPU | RAM | IP | Taint |
|------|-------|------|-----|-----|----|-------|
| cp-1 | 100 | controlplane | 4 | 16 GB | 10.40.1.70 | -- |
| worker-1 | 101 | worker | 6 | 16 GB | 10.40.1.71 | -- |
| worker-2 | 102 | worker | 6 | 16 GB | 10.40.1.72 | -- |
| worker-3 | 103 | worker | 6 | 16 GB | 10.40.1.73 | -- |
| runner-1 | 105 | worker | 4 | 8 GB | 10.40.1.74 | `workload/forgejo-actions=true:NoSchedule` |

**Talos version**: v1.7.5
**Extensions**: iscsi-tools, qemu-guest-agent
**CNI**: Cilium 1.19.0 (kube-proxy replacement)
**GitOps**: ArgoCD 9.4.0 (bootstrapped by Terraform)

### Bootstrapped Helm releases

The `talos-cluster` component installs three Helm charts as part of the initial provisioning:

1. **prometheus-operator-crds** -- CRDs needed by monitoring stack
2. **Cilium** -- CNI with kube-proxy replacement
3. **ArgoCD** -- GitOps controller that manages all other workloads

### Node labels and taints

All nodes have topology labels (`topology.kubernetes.io/region: homelab`, `topology.kubernetes.io/zone: pve`) required by the Proxmox CSI driver.

Nodes support optional `node_labels` and `node_taints` maps in `stacks/platform.yaml`. Taints use the format `value:Effect` and are applied via kubelet `register-with-taints` (only takes effect on first node registration):

```yaml
nodes:
  - name: "runner-1"
    node_labels:
      workload/forgejo-actions: "true"
    node_taints:
      workload/forgejo-actions: "true:NoSchedule"
```

The `runner-1` node is dedicated to Forgejo Actions runners. Workloads targeting it need a matching toleration and `nodeSelector`.

### Apply from a host that can reach the nodes

The Talos provider connects to each node at `<node_ip>:50000`. Run apply from a host with network route to the node IPs (same LAN, Tailscale, or VPN).

### Node IPs and bootstrap

- **`ip_cidr`** -- address Terraform uses to connect to each node.
- **`static_ip_cidr`** -- use when nodes have a temporary DHCP IP; set `ip_cidr` to the current IP and `static_ip_cidr` to the desired static IP.
- **`cluster_endpoint`** -- control plane API URL (`https://10.40.1.70:6443`).

### Kubeconfig and talosconfig

```bash
make kubeconfig   # saves to ~/.kube/config and 1Password
make talosconfig  # saves to ~/.talos/config and 1Password
```

Or manually:

```bash
atmos terraform output talos-cluster -s platform talos_cluster -o json \
  | jq -r '.kubeconfig_raw' > kubeconfig-platform
chmod 600 kubeconfig-platform
export KUBECONFIG=$(pwd)/kubeconfig-platform
kubectl get nodes
```

## Tailscale subnet router

The `tailscale` stack provisions an LXC container (ID 104, IP 10.40.0.10) running Tailscale as a subnet router advertising `10.40.0.0/21`.

### Workflows

```bash
atmos workflow tailscale/apply      # create/update the LXC container
atmos workflow tailscale/configure  # run Ansible to configure Tailscale
atmos workflow tailscale/drift      # check for configuration drift
```

## Proxmox Terraform user setup

If the Proxmox host was reinstalled or the user was lost, recreate the API user:

```bash
ssh root@<proxmox-host>

pveum user add terraform-user@pve
pveum acl modify / --users terraform-user@pve --roles Administrator
pveum user token add terraform-user@pve tf-token --privsep 0
```

Update the generated token in 1Password (`Proxmox Terraform Token`):
- **username**: `terraform-user@pve!tf-token`
- **password**: the secret printed by the last command

### Importing existing VMs after restore

If VMs were restored from backup (e.g. PBS) and Terraform state is out of sync:

```bash
# Remove stale state entries
atmos terraform state talos-cluster rm -s platform 'module.vm.proxmox_virtual_environment_vm.nodes["cp-1"]'

# Import with format: <proxmox-node>/<vm-id>
atmos terraform import talos-cluster -s platform 'module.vm.proxmox_virtual_environment_vm.nodes["cp-1"]' pve/100
```

## Notes

- **Storage**: VMs use `local-ssd` (LVM-thin). LXC containers use `local-ssd` for disks.
- **Proxmox VM tags**: only letters, numbers, hyphens, and underscores.
- **Talos CPU requirement**: x86-64-v2 or higher (the component defaults to `x86-64-v2-AES`).
- **Terraform backend**: Terraform Cloud, organization `the-lab-zone`.
- **Network**: `10.40.0.0/21` subnet. Gateway `10.40.0.1`.
