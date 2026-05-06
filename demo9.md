# Hands-on Lab: ACR Integration with AKS for Deployment

This lab guides you through integrating Azure Container Registry (ACR) with Azure Kubernetes Service (AKS) and deploying a sample application. All steps use the Azure CLI.

---

## Prerequisites

- Azure CLI installed and logged in (`az login`)
- Sufficient permissions to create resources
- Docker installed (for image build/push)

---

## 1. Create Azure Container Registry (ACR)

> Use powershell only

```sh
# Variables
$ACR_NAME="myaksacr$RANDOM"
$RESOURCE_GROUP="aks-demo-rg"
$LOCATION="eastus"

# Create resource group
az group create --name $RESOURCE_GROUP --location $LOCATION

# Create ACR
az acr create --resource-group $RESOURCE_GROUP --name $ACR_NAME --sku Basic --admin-enabled true

# Get ACR login server
$ACR_LOGIN_SERVER=$(az acr show --name $ACR_NAME --query "loginServer" -o tsv)
```

---

## 2. Create AKS Cluster Integrated with ACR

```sh
# Create AKS cluster and attach ACR
az aks create --resource-group $RESOURCE_GROUP  --name myaks900  --node-count 1  --generate-ssh-keys --attach-acr $ACR_NAME  --node-vm-size "Standard_d2s_v6"

# Get AKS credentials
az aks get-credentials --resource-group $RESOURCE_GROUP --name myakscluster
```

---

## 3. Push Sample Image to ACR

```sh
az acr import -n $ACR_NAME --source docker.io/mahendrshinde/myweb:1 --image myweb:latest
```

---

## 4. Deploy Sample Web App to AKS from ACR

```sh
# Create Kubernetes deployment using image from ACR
kubectl create deployment myweb --image=$ACR_LOGIN_SERVER/myweb:1

# Expose the deployment as a LoadBalancer service
kubectl expose deployment myweb --type=LoadBalancer --port 80 --target-port 80

# Get the external IP
kubectl get service myweb
```

---

## 5. Clean Up Resources

```sh
# Delete resource group and all resources
az group delete --name $RESOURCE_GROUP --yes --no-wait
```

---

## Summary

You have successfully integrated ACR with AKS, pushed a sample image, and deployed a web app using Azure CLI. This workflow is foundational for secure and automated container deployments in production.
