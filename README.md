# The Lab Zone

Infrastructure-as-code for the homelab, built with Atmos and Terraform modules.

## Structure

- `iac/atmos.yaml`: Atmos configuration.
- `iac/components/terraform/modules/`: Reusable Terraform modules.
- `iac/components/terraform/components/`: Atmos Terraform components.
- `iac/stacks/`: Stack definitions and environment manifests.

## Getting started

1. Install dependencies listed in `.tool-versions`.
2. Configure environment variables with `.env.tpl` and load them via `.envrc`.
3. Use `atmos` to plan or apply stacks.

## Notes

- `iac/stacks/catalog/_default.yaml` provides default values for stacks.
- `iac/stacks/platform/consul.yaml` defines the Consul platform stack.
