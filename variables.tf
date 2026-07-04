variable "source_subscription_id" {}
variable "dest_subscription_id" {}

variable "source_storage_account_name" {
  description = "Source storage account name used by the Storage Mover source endpoint"
}

variable "source_storage_account_resource_group" {
  description = "Resource group for the source storage account"
}

variable "dest_storage_account_name" {
  description = "Destination storage account name used by the target endpoint"
}

variable "dest_storage_account_resource_group" {
  description = "Resource group for the destination storage account"
}

variable "destination_container_name" {}
variable "source_container_path" {}
variable "arc_vm_resource_id" {}
variable "arc_vm_uuid" {}

variable "storage_mover_resource_group_name" {
  description = "Resource group where Storage Mover resources will be deployed"
  default     = "pmaguard-eu-sdc-nonprod-adb-managed"
}

variable "storage_mover_location" {
  description = "Azure region for Storage Mover resources"
  default     = "swedencentral"
}

variable "storage_mover_name" {
  description = "Name of the Storage Mover resource"
  default     = "pmaguard-cross-region-mover-nonprod"
}

variable "storage_mover_project_name" {
  description = "Name of the Storage Mover project"
  default     = "pmaguard-westeu-to-swedencentral-nonprod"
}

variable "storage_mover_job_definition_name" {
  description = "Name of the Storage Mover job definition"
  default     = "job-pmaguard-blob-migration-nonprod"
}

variable "source_endpoint_name" {
  description = "Storage Mover source endpoint name"
  default     = "source-pmaguard-testsa-westeurope"
}

variable "target_endpoint_name" {
  description = "Storage Mover target endpoint name"
  default     = "dest-dbstorage-swedencentral-nonprod"
}

variable "common_tags" {
  type    = map(string)
  default = {}
}
