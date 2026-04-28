# Infrastructure as Code (IaC) with Terraform

This module will guide you through using Terraform for Azure Kubernetes Service (AKS) operations. You will learn the basics of Terraform, how to manage state, deploy an AKS cluster, detect configuration drift, and reapply state. A hands-on demo Terraform script is included.

---

## 1. Terraform Introduction

Terraform is an open-source Infrastructure as Code (IaC) tool by HashiCorp. It enables you to define, provision, and manage cloud infrastructure using declarative configuration files. Terraform supports multiple cloud providers, including Azure, AWS, and GCP.

**Key Concepts:**
- **Providers:** Plugins to interact with cloud platforms (e.g., Azure Provider).
- **Resources:** Infrastructure components (e.g., Azure resource group, AKS cluster).
- **Modules:** Reusable configuration units.
- **State:** Terraform tracks infrastructure state in a state file.

**Benefits:**
- Version-controlled infrastructure
- Automated, repeatable deployments
- Easy collaboration and review

---

## 2. Terraform State Management

Terraform maintains a state file (`terraform.tfstate`) to map your configuration to real-world resources. This file is critical for tracking resource changes and dependencies.

**Best Practices:**
- Store state remotely (e.g., Azure Storage) for team collaboration.
- Enable state locking to prevent concurrent changes.
- Protect state files as they may contain sensitive data.

**Remote State Example (Azure Storage):**
```hcl
terraform {
	backend "azurerm" {
		resource_group_name  = "tfstate-rg"
		storage_account_name = "tfstateaccount"
		container_name       = "tfstate"
		key                  = "terraform.tfstate"
	}
}
```

---

## 3. Deploying AKS Cluster with Terraform

Below is a minimal example of a Terraform script to deploy an AKS cluster in Azure. This script creates a resource group and a basic AKS cluster with a system-assigned managed identity.

**Directory structure:**
```
aks-terraform-demo/
├── main.tf
├── variables.tf
├── outputs.tf
```

**main.tf:**
```hcl
provider "azurerm" {
	features {}
}

resource "azurerm_resource_group" "aks_rg" {
	name     = var.resource_group_name
	location = var.location
}

resource "azurerm_kubernetes_cluster" "aks" {
	name                = var.aks_cluster_name
	location            = azurerm_resource_group.aks_rg.location
	resource_group_name = azurerm_resource_group.aks_rg.name
	dns_prefix          = "aksdemo"

	default_node_pool {
		name       = "system"
		node_count = 2
		vm_size    = "Standard_B2s"
	}

	identity {
		type = "SystemAssigned"
	}
}
```

**variables.tf:**
```hcl
variable "resource_group_name" {
	default = "aks-demo-rg"
}

variable "location" {
	default = "eastus"
}

variable "aks_cluster_name" {
	default = "aks-demo-cluster"
}
```

**outputs.tf:**
```hcl
output "kube_config" {
	value = azurerm_kubernetes_cluster.aks.kube_config_raw
	sensitive = true
}
```

**How to use:**
1. Install [Terraform](https://www.terraform.io/downloads.html) and [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli).
2. Run `az login` to authenticate.
3. Initialize Terraform:
	 ```sh
	 terraform init
	 ```
4. Review the plan:
	 ```sh
	 terraform plan
	 ```
5. Apply the configuration:
	 ```sh
	 terraform apply
	 ```

---

## 4. Detecting Drift

Drift occurs when the real infrastructure differs from your Terraform configuration (e.g., manual changes in Azure Portal). To detect drift:

- Run `terraform plan` to see proposed changes.
- Terraform will show any differences between the state file and actual resources.

**Tip:** Regularly run `terraform plan` to ensure your infrastructure matches your code.

---

## 5. Reapplying Terraform State for AKS Cluster

If drift is detected or you want to enforce your desired configuration, reapply the state:

```sh
terraform apply
```

Terraform will reconcile the actual state with your configuration, making only the necessary changes.
