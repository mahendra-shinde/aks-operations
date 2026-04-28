
# Step-by-Step Guide: Deploying Azure Resources with Terraform

This learning module will guide you through deploying Azure resources using Terraform, focusing on best practices, explanations, and hands-on steps. The outline below is expanded with detailed instructions and context for new learners.

---

## 1. Prerequisites

Before you begin, ensure you have the following tools installed:

- **Azure CLI**: Used to authenticate and manage Azure resources from the command line.
- **Terraform CLI**: Used to define, plan, and apply infrastructure changes.

**Check Azure CLI installation:**
```sh
az version
```

**Check Terraform installation:**
```sh
terraform version
```

---

## 2. Authenticate with Azure

You must log in to Azure to allow Terraform to provision resources on your behalf.

**Login to Azure CLI:**
```sh
az login
```
A browser window will open for you to enter your Azure credentials. After successful login, return to your terminal.

**Verify your account:**
```sh
az account show
```

---

## 3. Prepare Your Terraform Project

Create a new folder for your Terraform project (e.g., `iac-demo`). Inside this folder, you will create the following files:

### main.tf
This file contains the main Terraform configuration for the Azure provider and resource group.

```hcl
provider "azurerm" {
	tenant_id       = "02XXXXXXXXXXXXXXXXXXXXXXX" # Replace with your Azure tenant ID
	subscription_id = "f4bXXXXXXXXXXXXXXXXXXX4c0" # Replace with your Azure subscription ID
	features {}
}

# Define a resource group to hold all AKS-related resources
resource "azurerm_resource_group" "aks_rg" {
	name     = var.resource_group_name
	location = var.location
}
```

### variables.tf
This file defines input variables for your Terraform configuration.

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

---

## 4. Initialize and Apply Terraform Configuration

Navigate to your project folder and run the following commands:

```sh
cd iac-demo
terraform init           # Initializes the working directory and downloads provider plugins
terraform plan -out=tfplan1   # Creates an execution plan and saves it to tfplan1
terraform apply tfplan1  # Applies the planned changes to Azure
```

---

## 5. Verify Resource Creation

After applying the configuration, use the Azure Portal or Azure CLI to verify that the resource group was created:

```sh
az group show --name aks-demo-rg
```

You should see details of the new resource group.

---

## 6. Best Practices and Next Steps

- Always use variables for configurable values.
- Store sensitive values (like client secrets) securely, not in plain text.
- Use remote state storage for team collaboration.
- Use `terraform plan` before every `apply` to review changes.
- Clean up resources when done to avoid unnecessary costs:
	```sh
	terraform destroy
	```

---

**Congratulations!** You have successfully deployed Azure resources using Terraform. Continue to expand your configuration to deploy more complex resources, such as AKS clusters, virtual networks, and more.