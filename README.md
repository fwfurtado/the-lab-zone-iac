# The Lab Zone

Infrastructure-as-code for the homelab, built with Atmos and Terraform modules.

## Structure

- `atmos.yaml`: Atmos configuration.
- `components/terraform/modules/`: Reusable Terraform modules.
- `components/terraform/components/`: Atmos Terraform components (e.g., Talos cluster, generic LXC container).
- `stacks/`: Stack definitions and environment manifests.
- `workflows/`: Atmos workflows for common operations.

## Getting started

1. Install dependencies listed in `.tool-versions`.
2. Configure environment variables with `.env.tpl` and load them via `.envrc`.
3. Use `atmos` to plan or apply stacks.

## Notes

- `stacks/catalog/_default.yaml` provides defaults for infra-style stacks (e.g. Proxmox LXC).
- `stacks/tailscale/tailscale.yaml` defines the Tailscale LXC stack.
- `stacks/traefik/traefik.yaml` defines the Traefik LXC stack.
- `workflows/infra.yaml` provides plan/apply/destroy workflows for these stacks.
