resource "azurerm_eventhub_namespace" "ehn" {
  name                = "${var.prefix}-${var.suffix}-ehn"
  location            = var.azure-region
  resource_group_name = var.resource-group-name
  sku                 = var.eventhub-namespace-sku

  tags = {
    environment = var.tag
  }
}

resource "azurerm_eventhub_namespace_authorization_rule" "ehnar" {
  name                = "${var.prefix}-${var.suffix}-nsauth-rule"
  namespace_name      = azurerm_eventhub_namespace.ehn.name
  resource_group_name = var.resource-group-name

  listen = var.namespace-authz-rule-listen
  send   = var.namespace-authz-rule-send
  manage = var.namespace-authz-rule-manage

  depends_on = [
    azurerm_eventhub_namespace.ehn
  ]
}

resource "azurerm_eventhub" "eh" {
  name                = "${var.prefix}-${var.suffix}-eh"
  namespace_name      = azurerm_eventhub_namespace.ehn.name
  resource_group_name = var.resource-group-name
  message_retention   = var.message-retention
  partition_count     = var.eventhub-partition-count

  depends_on = [
    azurerm_eventhub_namespace.ehn
  ]
}

resource "azurerm_eventhub_authorization_rule" "ehar" {
  name                = "${var.prefix}-${var.suffix}-ehauth-rule"
  namespace_name      = azurerm_eventhub_namespace.ehn.name
  eventhub_name       = azurerm_eventhub.eh.name
  resource_group_name = var.resource-group-name

  listen = var.eventhub-authz-rule-listen
  send   = var.eventhub-authz-rule-send
  manage = var.eventhub-authz-rule-manage

  depends_on = [
    azurerm_eventhub.eh
  ]
}

resource "azurerm_eventhub_consumer_group" "ehcg" {
  name                = "${var.prefix}-${var.suffix}-ehcg"
  namespace_name      = azurerm_eventhub_namespace.ehn.name
  eventhub_name       = azurerm_eventhub.eh.name
  resource_group_name = var.resource-group-name

  depends_on = [
    azurerm_eventhub.eh
  ]
}
