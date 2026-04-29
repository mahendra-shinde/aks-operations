terraform {
  backend "azurerm" {
    resource_group_name  = "rg-aks-demo"
    storage_account_name = "<your_storage_account>"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
	features {}
}

resource "azurerm_resource_group" "aks" {

	name     = var.resource_group_name
	location = var.location
}

resource "azurerm_kubernetes_cluster" "aks" {
	name                = var.aks_cluster_name
	location            = azurerm_resource_group.aks.location
	resource_group_name = azurerm_resource_group.aks.name
	dns_prefix          = var.dns_prefix

	default_node_pool {
		name       = "system"
		node_count = 2
		vm_size    = "Standard_D2s_v6"
		type       = "VirtualMachineScaleSets"
	}

	identity {
		type = "SystemAssigned"
	}

	network_profile {
		network_plugin    = "azure"
		load_balancer_sku = "standard"
	}
}



output "resource_group_name" {
	value = azurerm_resource_group.aks.name
}

output "api_server_url" {
	value = azurerm_kubernetes_cluster.aks.kube_config[0].host
}