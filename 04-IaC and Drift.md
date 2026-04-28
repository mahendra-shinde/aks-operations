# Infrastructure as Code (IaC) with Terraform and Managing Drift

This module expands on AKS operations by introducing Infrastructure as Code (IaC) with Terraform, the concept of configuration drift, and how to detect and manage drift using Terraform. It is designed as a learning resource for both beginners and practitioners.

---

## Table of Contents
1. What is Infrastructure as Code (IaC)?
2. Introduction to Terraform
3. Key Terraform Concepts
4. What is Drift and Why Does It Matter?
5. How to Prevent Drift
6. How Terraform Helps Manage Drift
7. Hands-on: Deploying AKS with Terraform
8. Summary and Best Practices

---

## 1. What is Infrastructure as Code (IaC)?

Infrastructure as Code (IaC) is the practice of managing and provisioning computing infrastructure through machine-readable configuration files, rather than manual processes. IaC enables automation, repeatability, and version control for infrastructure, similar to how source code is managed.

**Benefits:**
- Consistency and repeatability
- Version control and auditability
- Faster, automated deployments
- Easier collaboration and review

---

## 2. Introduction to Terraform

Terraform is an open-source IaC tool by HashiCorp. It allows you to define, provision, and manage cloud infrastructure using declarative configuration files. Terraform supports multiple cloud providers, including Azure, AWS, and GCP.

**Why Terraform?**
- Cloud-agnostic
- Declarative syntax (HCL)
- Large provider ecosystem
- Strong community and documentation

---

## 3. Key Terraform Concepts

- **Providers:** Plugins to interact with cloud platforms (e.g., Azure Provider)
- **Resources:** Infrastructure components (e.g., Azure resource group, AKS cluster)
- **Modules:** Reusable configuration units
- **State:** Terraform tracks infrastructure state in a state file (`terraform.tfstate`)

**Terraform Workflow:**
1. Write configuration files (`.tf`)
2. Initialize the working directory (`terraform init`)
3. Review the execution plan (`terraform plan`)
4. Apply changes (`terraform apply`)
5. Manage state and outputs

---

## 4. What is Drift and Why Does It Matter?

**Drift** occurs when the actual state of your infrastructure differs from the state defined in your IaC configuration. This can happen due to manual changes in the cloud portal, scripts, or other tools outside of Terraform.

**Why Drift Matters:**
- Causes inconsistencies between expected and actual infrastructure
- Can introduce security risks or outages
- Makes troubleshooting and auditing difficult
- Undermines the benefits of IaC

**Examples of Drift:**
- Manually changing VM sizes in the Azure Portal
- Deleting or modifying resources outside of Terraform

---

## 5. How to Prevent Drift

**Best Practices:**
- Use IaC tools (like Terraform) as the single source of truth
- Avoid manual changes in the cloud portal
- Use remote state storage and state locking for team environments
- Regularly run `terraform plan` to detect drift
- Implement policy and access controls to restrict manual changes

---

## 6. How Terraform Helps Manage Drift

Terraform helps you detect and remediate drift:

- **Drift Detection:**
	- Run `terraform plan` to compare your configuration and state file with real infrastructure. Any differences are shown as proposed changes.
- **Drift Remediation:**
	- Run `terraform apply` to reconcile the actual infrastructure with your configuration, making only the necessary changes.
- **State Management:**
	- Store state remotely (e.g., Azure Storage) for collaboration and locking.

**Tip:** Regularly running `terraform plan` and `terraform apply` ensures your infrastructure matches your code.

---

## 7. Hands-on: Deploying AKS with Terraform

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
	value     = azurerm_kubernetes_cluster.aks.kube_config_raw
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

**Detecting Drift:**
- Run `terraform plan` to see proposed changes and detect drift.
- If drift is detected, run `terraform apply` to reconcile the state.

---

## 8. Summary and Best Practices

- Use Terraform or other IaC tools as the single source of truth for infrastructure
- Avoid manual changes in the cloud portal
- Store state remotely and enable locking for team environments
- Regularly run `terraform plan` to detect drift
- Use version control for all configuration files
