# Create and Test AKS Cluster

This hands-on exercise will guide you through the process of creating and testing an Azure Kubernetes Service (AKS) cluster. Follow each step to gain practical experience with AKS setup and basic operations.

## 1. Create a New Resource Group

Resource groups in Azure are logical containers for resources. Creating a dedicated resource group for your AKS cluster helps with organization and cleanup.

**Step-by-step:**
1. Open the [Azure Portal](https://portal.azure.com/) or use [Azure Cloud Shell](https://shell.azure.com/).
2. Run the following command to create a resource group (replace `<region>` with your preferred Azure region, e.g., `eastus`):
	```sh
	az group create --name aks-demo-rg --location eastus
	```

## 2. Create AKS Cluster with Basic Plan

You will create an AKS cluster using the Basic (Dev/Test) plan, with a system node pool of smaller VM size and manual scaling to 2 nodes.

**Step-by-step:**
1. Choose a VM size suitable for development/testing (e.g., `Standard_B2s`).
2. Run the following command to create the AKS cluster:
	```sh
	az aks create --resource-group aks-demo-rg --name aks-demo-cluster --node-count 2 --node-vm-size Standard_B2s --enable-managed-identity --generate-ssh-keys --tier Free
	```

	- `--node-count 2`: Sets the initial number of nodes.
	- `--node-vm-size`: Specifies the VM size for the node pool.
	- `--tier Free`: Uses the Basic (Dev/Test) plan.

## 3. Connect to AKS Cluster Using Cloud Shell

Azure Cloud Shell provides a browser-based shell experience with Azure CLI pre-installed.

**Step-by-step:**
1. In Cloud Shell, configure `kubectl` to connect to your AKS cluster:

	```sh
	az aks get-credentials --resource-group aks-demo-rg --name aks-demo-cluster
	```
2. Verify the connection and view cluster nodes:

	```sh
	kubectl get nodes
	```
	You should see two nodes listed, indicating your cluster is ready.


3. Try few kubectl commands to test cluster

    ```sh
    kubectl cluster-info
    kubectl config view
    kubectl top nodes
    kubectl get pods -n kube-system
    kubectl events
    ```

> Kubernetes Object types can written THREE forms pods, pod, po 

4. To delete everything, just delete the first resource group `aks-demo-rg`

    ```sh
    az group delete -n aks-demo-rg
    ```