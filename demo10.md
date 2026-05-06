# Hands-on Lab: AKS Integration with Azure RBAC

This lab guides you through integrating Azure Kubernetes Service (AKS) with Azure RBAC, including user creation, cluster deployment, and access validation. All steps use the Azure CLI.

---


## Prerequisites

- Azure CLI installed and logged in (`az login`)
- kubectl installed
- kubelogin installed (required for Azure RBAC authentication)
- Sufficient permissions to create users and resources

---


## 1. Set Up Variables and Use Existing Signed-In User

```sh
# Variables
$RESOURCE_GROUP="aks-rbac-demo-rg"
$LOCATION="eastus"
# Set a unique name
$AKS_NAME="myaksrbaccluster"
# Get the signed-in user's object ID
$SIGNED_IN_USER_OBJECT_ID=$(az ad signed-in-user show --query userPrincipalName -o tsv)
```

---

## 2. Deploy AKS Cluster with Azure RBAC Enabled

```sh
# Create resource group
az group create --name $RESOURCE_GROUP --location $LOCATION

# Deploy AKS with Azure RBAC enabled
az aks create --resource-group $RESOURCE_GROUP --name $AKS_NAME --enable-aad --enable-azure-rbac --node-count 1 --generate-ssh-keys --node-vm-size "standard_d2s_v6"
```

---


## 3. Assign AKS RBAC Role to the Signed-In User

```sh
# Assign 'Azure Kubernetes Service RBAC Cluster Admin' role to the signed-in user
az role assignment create --assignee $SIGNED_IN_USER_OBJECT_ID --role "Azure Kubernetes Service RBAC Cluster Admin" --scope $(az aks show --resource-group $RESOURCE_GROUP --name $AKS_NAME --query id -o tsv)
```

---



## 4. Connect to AKS Cluster Using Your Azure Credentials

### Install kubelogin (if not already installed)

```sh
## Check if kubelogin is installed 
kubelogin --version 

# Install kubelogin using Azure CLI 
az aks install-cli
```

### Authenticate and connect

```sh
# Ensure you are logged in as the intended user
az login

# Get AKS credentials (this will configure kubectl to use kubelogin for authentication)
az aks get-credentials --resource-group $RESOURCE_GROUP --name $AKS_NAME

# Test access
kubectl get nodes
```

---

## 5. Clean Up Resources

```sh
# Delete resource group and all resources
az group delete --name $RESOURCE_GROUP --yes --no-wait
```

---

## Summary

You have successfully used your existing Azure user, deployed an AKS cluster with Azure RBAC, assigned access, and validated connectivity using Azure credentials. This process is essential for secure, role-based operations in production AKS environments.
