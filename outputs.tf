output "storage_mover_id" {
  value = azurerm_storage_mover.main.id
}

output "job_definition_id" {
  value = azurerm_storage_mover_job_definition.blob_migration.id
}

output "mover_principal_id" {
  description = "Use this to verify IAM assignments"
  value       = azurerm_storage_mover.main.identity[0].principal_id
}
