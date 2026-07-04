resource "azurerm_storage_mover" "main" {
  provider            = azurerm.dest_sub
  name                = var.storage_mover_name
  resource_group_name = var.storage_mover_resource_group_name
  location            = var.storage_mover_location
  tags                = var.common_tags
}

resource "azurerm_storage_mover_project" "migration" {
  name             = var.storage_mover_project_name
  storage_mover_id = azurerm_storage_mover.main.id
}

resource "azurerm_storage_mover_source_endpoint" "source" {
  name             = var.source_endpoint_name
  storage_mover_id = azurerm_storage_mover.main.id
  host             = "${var.source_storage_account_name}.dfs.core.windows.net"
}

resource "azurerm_storage_mover_target_endpoint" "destination" {
  name                   = var.target_endpoint_name
  storage_mover_id       = azurerm_storage_mover.main.id
  storage_account_id     = format(
    "/subscriptions/%s/resourceGroups/%s/providers/Microsoft.Storage/storageAccounts/%s",
    var.dest_subscription_id,
    var.dest_storage_account_resource_group,
    var.dest_storage_account_name
  )
  storage_container_name = var.destination_container_name
}

resource "azurerm_storage_mover_agent" "main" {
  name                     = "pmaguard-mover-agent-nonprod"
  storage_mover_id         = azurerm_storage_mover.main.id
  arc_virtual_machine_id   = var.arc_vm_resource_id
  arc_virtual_machine_uuid = var.arc_vm_uuid
}

resource "azurerm_storage_mover_job_definition" "blob_migration" {
  name                     = var.storage_mover_job_definition_name
  storage_mover_project_id = azurerm_storage_mover_project.migration.id
  agent_name               = azurerm_storage_mover_agent.main.name
  source_name              = azurerm_storage_mover_source_endpoint.source.name
  target_name              = azurerm_storage_mover_target_endpoint.destination.name
  copy_mode                = "Additive"
  source_sub_path          = var.source_container_path
}
