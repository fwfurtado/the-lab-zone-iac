# The Lab Zone

Infrastructure-as-code for the homelab: Proxmox VMs (Talos Kubernetes), LXC containers (Traefik, Tailscale), managed with Atmos and OpenTofu/Terraform.

## Structure

| Path | Description |
|------|-------------|
| `atmos.yaml` | Atmos configuration |
| `components/terraform/modules/` | Reusable modules (e.g. `vm`, `lxc`) |
| `components/terraform/components/` | Atmos Terraform components (`talos-cluster`, `traefik`, `tailscale`) |
| `stacks/` | Stack definitions (vars per environment) |
| `stacks/catalog/` | Shared defaults for stacks |
| `workflows/` | Atmos workflows |

## Getting started

1. **Dependencies**
   Install tools from `.tool-versions` (e.g. via asdf).

2. **Environment**
   Copy `.env.tpl` to `.env`, fill in Proxmox (and any other) credentials. Load with `direnv` (`.envrc`) or source manually.

3. **Plan / apply**
   Use Atmos to target a stack and component:

   ```bash
   atmos terraform plan talos-cluster -s platform
   atmos terraform apply talos-cluster -s platform
   ```

## Stacks

| Stack | Component | Description |
|-------|-----------|-------------|
| `platform` | `talos-cluster` | Talos OS Kubernetes cluster (control plane + worker) on Proxmox VMs |
| `tailscale` | (LXC) | Tailscale subnet router (LXC) |
| `traefik` | (LXC) | Traefik edge proxy (LXC) |

Workflows for LXC stacks: see `workflows/lxc.yaml`.

## Talos platform cluster

The `platform` stack provisions a 2-node Talos cluster (control plane + worker) as VMs on Proxmox.

### Apply from a host that can reach the nodes

The Talos provider connects to each node at `<node_ip>:50000`. **Run `atmos terraform apply` from a host that has network route to the node IPs** (e.g. same LAN as Proxmox, or via Tailscale/VPN). Otherwise you get `no route to host`.

```bash
atmos terraform apply talos-cluster -s platform -auto-approve
```

### Node IPs and bootstrap

- **`ip_cidr`** in the stack is the address Terraform uses to connect to each node.
- If nodes get DHCP first and you want static IPs, use **`static_ip_cidr`** for the IP to configure in Talos; set **`ip_cidr`** to the current (e.g. DHCP) IP so Terraform can connect. After the first apply, switch the stack to the final IPs (see `stacks/platform.yaml` comments).
- **`cluster_endpoint`** should be the control plane API URL (e.g. `https://10.40.0.20:6443`).

### Connecting to the cluster (kubeconfig)

After a successful apply, the component outputs the cluster kubeconfig. Save it and use it with `kubectl`:

```bash
atmos terraform output talos-cluster -s platform talos_cluster -o json | jq -r '.kubeconfig_raw' > kubeconfig-platform
chmod 600 kubeconfig-platform
export KUBECONFIG=$(pwd)/kubeconfig-platform
kubectl get nodes
```

Your machine must be able to reach the control plane (e.g. `10.40.0.20:6443`). Use the same LAN, Tailscale, or VPN as for the apply.

## Notes

- **Proxmox VM tags**: only letters, numbers, hyphens, and underscores (e.g. `cluster-platform`, not `cluster:platform`).
- **Talos on Proxmox**: VMs need CPU type at least x86-64-v2 (e.g. `x86-64-v2-AES`). The component sets this by default; the generic `vm` module defaults to `qemu64`.
- **Catalog**: `stacks/catalog/_vm.yaml` and `stacks/catalog/_lxc.yaml` (and nested configs) provide defaults for stacks.
- For architecture and GitOps context, see [CLAUDE.md](CLAUDE.md).
