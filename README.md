# The Lab Zone

Infrastructure-as-code for the homelab, built with Atmos and Terraform modules.

## Structure

- `atmos.yaml`: Atmos configuration.
- `components/terraform/modules/`: Reusable Terraform modules.
- `components/terraform/components/`: Atmos Terraform components (e.g., Tailscale, Traefik).
- `stacks/`: Stack definitions and environment manifests.
- `workflows/`: Atmos workflows for common operations.

## Getting started

1. Install dependencies listed in `.tool-versions`.
2. Configure environment variables with `.env.tpl` and load them via `.envrc`.
3. Use `atmos` to plan or apply stacks.

## Notes

- `stacks/catalog/_default.yaml` provides defaults for infra stacks.
- `stacks/infra/tailscale.yaml` and `stacks/infra/traefik.yaml` define the infra stacks.
- `workflows/infra.yaml` provides plan/apply/destroy workflows.
