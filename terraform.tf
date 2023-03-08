# Configure Terraform to set the required AzureRM provider
# version and features{} block.

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.19.0"
    }
  }
}

# provider "azurerm" {
#   features {}
# }
provider "azurerm" {
  features {}
  subscription_id   = "47f36dd9-76ae-4fb7-80aa-adb7a38b3131"
  tenant_id         = "c9bd6e95-3207-4432-837b-4ea2a157e31b"
  client_id         = "07971568-af14-45e6-85b3-8c545d45061b"
  client_secret     = "Kmf8Q~v_iVJfx1xU~6OcGuxDYMDno3kL-UcHnaes"
}
# Get the current client configuration from the AzureRM provider.
# This is used to populate the root_parent_id variable with the
# current Tenant ID used as the ID for the "Tenant Root Group"
# Management Group.

data "azurerm_client_config" "core" {}

# Declare the Azure landing zones Terraform module
# and provide a base configuration.

module "enterprise_scale" {
  source  = "Azure/caf-enterprise-scale/azurerm"
  version = "3.2.0"

  providers = {
    azurerm              = azurerm
    azurerm.connectivity = azurerm
    azurerm.management   = azurerm
  }


  root_parent_id = data.azurerm_client_config.core.tenant_id
  root_id        = var.root_id
  root_name      = var.root_name

  deploy_management_resources    = var.deploy_management_resources
  subscription_id_management     = data.azurerm_client_config.core.subscription_id
  configure_management_resources = local.configure_management_resources

}
