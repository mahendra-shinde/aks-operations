# Demo: Terraform State Management and Drift Detection in AKS Cluster

This demo will guide you through the concepts and hands-on steps for managing Terraform state and detecting configuration drift in an Azure Kubernetes Service (AKS) cluster deployment.

---

## 1. **Introduction to Terraform State**

Terraform uses a state file to keep track of resources it manages. This file is critical for:
- Mapping real-world resources to your configuration
- Tracking metadata
- Improving performance

**Types of State Storage:**
- Local state (default, stored as `terraform.tfstate`)
- Remote state (recommended for teams, e.g., Azure Storage Account)

---

## 2. **Setting Up Remote State in Azure**

### a. **Create an Azure Storage Account for State**

```sh
# Variables
$RESOURCE_GROUP="rg-aks-demo"
# Replace with Unique name
$STORAGE_ACCOUNT="tfstateaksdemo575765"
$CONTAINER_NAME="tfstate"

# Create resource group (if not exists)
az group create --name $RESOURCE_GROUP --location eastus

# Create storage account
az storage account create --name $STORAGE_ACCOUNT --resource-group $RESOURCE_GROUP --sku Standard_LRS

# Get storage account key
$ACCOUNT_KEY=$(az storage account keys list --resource-group $RESOURCE_GROUP --account-name $STORAGE_ACCOUNT --query '[0].value' -o tsv)

# Create blob container
az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT --account-key $ACCOUNT_KEY
```

### b. **Configure Backend in Terraform**

Add the following to your `main.tf` :

```hcl
terraform {
  backend "azurerm" {
    resource_group_name  = "rg-aks-demo"
    storage_account_name = "<your_storage_account>"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}
```

Initialize the backend:

```sh
terraform init
```

---

## 3. **Terraform State Operations**

- **Show current state:**
  ```sh
  terraform state list
  ```
- **Inspect a resource:**
  ```sh
  terraform state show <resource_type.resource_name>
  ```
- **Remove a resource from state (not from Azure):**
  ```sh
  terraform state rm <resource_type.resource_name>
  ```
- **Import existing resource:**
  ```sh
  terraform import <resource_type.resource_name> <resource_id>
  ```

---

## 4. **Drift Detection**

Drift occurs when the real infrastructure diverges from the Terraform configuration/state.

### a. **Detecting Drift**

- **Run Terraform Plan:**
  ```sh
  terraform plan
  ```
  - If there are changes, Terraform will show what is different (drifted).

- **Example:**
  1. Manually change the AKS node count in the Azure Portal.
  2. Run `terraform plan` again. Terraform will detect the drift and show the difference.

### b. **Reconciling Drift**

- **To fix drift:**
  - Update your configuration to match the real state, or
  - Run `terraform apply` to bring the infrastructure back in sync with your code.

---

## 5. **Best Practices**

- Always use remote state for team environments.
- Enable state locking to prevent concurrent changes.
- Regularly back up your state file.
- Use `terraform plan` before every `apply` to detect drift early.

---

## 6. **Cleanup**

To remove all resources:
```sh
terraform destroy
```

To delete the storage account (state):
```sh
az storage account delete --name <your_storage_account> --resource-group rg-aks-demo
```

---

## 7. **References**
- [Terraform State Documentation](https://developer.hashicorp.com/terraform/language/state)
- [Terraform AzureRM Backend](https://developer.hashicorp.com/terraform/language/settings/backends/azurerm)
- [Terraform Drift Detection](https://developer.hashicorp.com/terraform/cli/commands/plan)

---

**End of Demo**
