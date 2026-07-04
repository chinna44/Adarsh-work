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
- Required repository secrets:
   - `AZURE_CLIENT_ID` — service principal client id
   - `AZURE_CLIENT_SECRET` — service principal secret
   - `AZURE_TENANT_ID` — tenant id
   - `AZURE_SUBSCRIPTION_ID_DEST` — destination subscription id (where Storage Mover will be deployed)
   - `MOVER_RG`, `MOVER_NAME`, `PROJECT_NAME`, `JOB_NAME` — needed for run-migration/check-status steps
   - (optional) `TEST_TFVARS` — entire `terraform.tfvars` content (workflow will write it to `Test/terraform.tfvars` if provided)

- How to trigger:
   - From Actions → select `Deploy Storage Mover - Test (non-prod)` → `Run workflow`.
   - Choose `env` (test/dev/pre) and `action` (`provision-infra`, `run-migration`, `check-status`, `teardown`).

- Notes & precautions:
   - The workflow assumes a `Test/terraform.tfvars` file exists (or you provide `TEST_TFVARS` secret).
   - GitHub-hosted runners are ephemeral and provided by GitHub — no self-hosted runner is required.
   - Do NOT commit secrets or real credentials to the repository. Use repository secrets.

If you want, I can also add a small helper action that decrypts an encrypted `terraform.tfvars.enc` artifact or generates `terraform.tfvars` from repository secrets.
