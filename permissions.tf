# ── Reader on SOURCE SA (cross-subscription) ──────────────────────────────────
resource "azurerm_role_assignment" "mover_source_reader" {
  provider             = azurerm.source_sub
  scope                = format(
    "/subscriptions/%s/resourceGroups/%s/providers/Microsoft.Storage/storageAccounts/%s",
    var.source_subscription_id,
    var.source_storage_account_resource_group,
    var.source_storage_account_name
  )
  role_definition_name = "Storage Blob Data Reader"
  principal_id         = azurerm_storage_mover.main.identity[0].principal_id
}

# ── Contributor on DESTINATION SA ─────────────────────────────────────────────
resource "azurerm_role_assignment" "mover_dest_contributor" {
  provider             = azurerm.dest_sub
  scope                = format(
    "/subscriptions/%s/resourceGroups/%s/providers/Microsoft.Storage/storageAccounts/%s",
    var.dest_subscription_id,
    var.dest_storage_account_resource_group,
    var.dest_storage_account_name
  )
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_storage_mover.main.identity[0].principal_id
}
