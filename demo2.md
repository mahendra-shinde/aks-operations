# Learning Guide: Connecting to a Private AKS Cluster Using a Jumpbox (Linux VM)

This guide will walk you through the process of securely connecting to a private Azure Kubernetes Service (AKS) cluster using a jumpbox (Linux VM) in Azure. This is a common scenario when your AKS cluster does not have a public endpoint and you need a secure way to access it for management and troubleshooting.

## Prerequisites

- Access to the Azure portal with sufficient permissions to create resources.
- An existing private AKS cluster deployed in your Azure subscription.

---

## Step 1: Identify the Virtual Network (VNet) of Your AKS Cluster

1. Log in to the [Azure Portal](https://portal.azure.com/).
2. Navigate to your AKS cluster resource.
3. In the left menu, select **Networking**.
4. Note the name of the **Virtual Network (VNet)** associated with your AKS cluster. You will deploy the jumpbox VM into this VNet.

---

## Step 2: Add a Subnet for the Jumpbox

1. In the Azure portal, go to the identified VNet.
2. Click on **Subnets** in the left menu.
3. Click **+ Subnet** to add a new subnet.
4. Name the subnet `jumpbox-sn` and leave other options as default unless your organization requires specific settings.
5. Click **Save**.

---

## Step 3: Create a Linux VM (Jumpbox) in the Same VNet

1. Go to **Virtual Machines** in the Azure portal and click **+ Create** > **Azure virtual machine**.
2. Fill in the following details:
  - **Resource Group**: Select the same resource group as your AKS cluster.
  - **Virtual Network**: Select the VNet used by your AKS cluster.
  - **Subnet**: Select the new `jumpbox-sn` subnet.
  - **Image**: Ubuntu 24.04 LTS.
  - **Size**: Standard_B1ms (suitable for admin tasks).
  - **Username**: Choose your preferred username.
  - **Authentication type**: Password (or SSH key if preferred).
  - **Password**: Set a strong password.
3. Under **Management**, enable **System assigned managed identity**.
4. Click **Review + create** and then **Create**.

---

## Step 4: Assign Azure Role to the Jumpbox VM

1. Once the VM is created, go to the VM resource in the portal.
2. In the left menu, select **Identity** under **Settings**.
3. Click **Azure role assignments** > **+ Add role assignment**.
4. Set the following:
  - **Scope**: Resource group
  - **Resource group**: Select the same as your AKS cluster
  - **Role**: Contributor
5. Click **Save**.

This allows the VM to access Azure resources in the resource group using its managed identity.

---

## Step 5: Connect to the Jumpbox VM

1. From your local machine, use SSH to connect to the VM. You can find the public IP address in the VM overview page.

```sh
ssh <username>@<jumpbox-public-ip>
```

---

## Step 6: Install Azure CLI and kubectl on the Jumpbox

Once connected to the VM via SSH, run the following commands to install the Azure CLI and kubectl:

```sh
sudo apt update -y
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo install kubectl /usr/bin/
```

Login to Azure using the VM's managed identity:

```sh
az login --identity
```

---

## Step 7: Connect to the Private AKS Cluster

1. In the Azure portal, navigate to your AKS cluster.
2. Click **Connect** in the left menu, then select **Azure CLI**.
3. Copy the two commands provided (these will look like `az account set ...` and `az aks get-credentials ...`).
4. Paste and run these commands in your SSH session on the jumpbox VM.

Example:

```sh
az account set --subscription <your-subscription-id>
az aks get-credentials --resource-group <aks-resource-group> --name <aks-cluster-name>
```

---

## Step 8: Verify kubectl Access

Test your connection to the AKS cluster:

```sh
kubectl get nodes
```

You should see a list of nodes in your AKS cluster, confirming successful access.

---

## Summary

You have now set up a secure jumpbox VM in the same VNet as your private AKS cluster, configured it with the necessary tools, and connected to your AKS cluster for management tasks. This approach is recommended for production environments where direct public access to the cluster is restricted for security reasons.
