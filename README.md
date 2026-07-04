# Test Terraform Deployment

This folder contains a non-prod copy of the Storage Mover Terraform deployment.

## What is included
- `provider.tf` - Azure provider definitions for source and destination subscriptions
- `variables.tf` - environment-specific values for the non-prod deployment
- `storage-mover.tf` - Storage Mover, project, endpoints, agent, and job definition
- `permissions.tf` - cross-subscription role assignment resources
- `outputs.tf` - deployment outputs
- `terraform.tfvars.example` - placeholder values for the new non-prod environment

## How to use
1. Copy `terraform.tfvars.example` to `terraform.tfvars`.
2. Replace placeholders with the new subscription IDs, storage account names, resource groups, container, and Arc VM values.
3. Run Terraform from the `Test` folder:
   - `terraform init -upgrade -backend-config="<your-backend-config>.tfvars"`
   - `terraform plan -var-file="terraform.tfvars"`
   - `terraform apply -var-file="terraform.tfvars" --auto-approve`

## Notes
- The new deployment is parameterized so it can target a fresh non-prod source and destination environment.
- The existing root code used hard-coded production resources; this folder uses variables for all environment-specific storage account details.
- You will still need to create the destination storage account/container and provide Arc VM credentials before running.

## GitHub Actions (GitHub-hosted runners)

- A workflow has been added at `.github/workflows/deploy-nonprod.yml` to run Terraform from the `Test` folder using GitHub-hosted runners (`ubuntu-latest`).
- This workflow uses the same style as the reference code: it reads values into `env.ARM_CLIENT_ID`, `env.ARM_TENANT_ID`, and `env.ARM_SUBSCRIPTION_ID` so your GitHub workflow behaves like the real pipeline.
- The workflow now uses only the GitHub Variables you already created. No fallback values are required.

### What to create in GitHub

1. Open your repository on GitHub.
2. Go to Settings → Secrets and variables → Actions.
3. Choose the tab you want:
   - Variables: for non-sensitive values such as subscription IDs, resource group names, and storage mover names.
   - Secrets: for sensitive values such as a client secret if you decide to use secret-based login.

### Recommended values

Create these as repository variables or environment variables for each environment (`test`, `dev`, `pre`):
- `ARM_CLIENT_ID`
- `ARM_TENANT_ID`
- `ARM_SUBSCRIPTION_ID`
- `MOVER_RG`
- `MOVER_NAME`
- `PROJECT_NAME`
- `JOB_NAME`
- `TEST_TFVARS` (optional, only if you want the workflow to write `Test/terraform.tfvars` automatically)

### How to trigger

- From Actions → select `Deploy Storage Mover - Test (non-prod)` → `Run workflow`.
- Choose `env` (`test`, `dev`, or `pre`) and `action` (`provision-infra`, `run-migration`, `check-status`, or `teardown`).

### Notes & precautions

- GitHub-hosted runners are ephemeral and provided by GitHub, so no self-hosted runner is required.
- Keep secrets only for sensitive values; keep the Azure IDs and names in Variables whenever possible.
- The workflow assumes a `Test/terraform.tfvars` file exists or that you provide `TEST_TFVARS`.
- Do not commit real credentials to the repository.

### Arc VM values

The Terraform variables `arc_vm_resource_id` and `arc_vm_uuid` must be populated in your `terraform.tfvars` file.

You can get them from Azure Arc:
1. Go to Azure Arc → Machines.
2. Open your Arc-enabled server.
3. Copy the Resource ID for `arc_vm_resource_id`.
4. Copy the VM ID or Machine UUID value for `arc_vm_uuid`.
