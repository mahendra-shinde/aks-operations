# Working with Azure CNI Network and Network Policy

This hands-on guide will help you understand how Azure CNI works in AKS, how to deploy a cluster with Azure CNI, and how to observe pod networking in action. You will also learn how to verify pod IP assignments and relate them to your Azure subnet.

---

## 1. Create AKS Cluster (Dev/Test, Free) with Single Node and Azure CNI

Azure CNI assigns each pod an IP address from the Azure VNet subnet, enabling direct communication with other Azure resources.

**Step-by-step:**
1. Open Azure Cloud Shell or your local terminal with Azure CLI installed.
2. Create a resource group:
	```sh
	az group create --name aks-cni-demo-rg --location eastus
	```
3. Create an AKS cluster with Azure CNI Node Subnet:
	```sh
	az aks create -g aks-cni-demo-rg --name aks-cni-demo  --node-count 1 --network-plugin azure 
    --enable-managed-identity --generate-ssh-keys --tier Free
    
	```
	- `--network-plugin azure` ensures Azure CNI is used.
	- `--tier Free` uses the Dev/Test plan.

---

## 2. Connect to Cluster and Verify Deployed System Pods

**Step-by-step:**
1. Get AKS credentials:
	```sh
	az aks get-credentials --resource-group aks-cni-demo-rg --name aks-cni-demo
	```
2. List all nodes:
	```sh
	kubectl get nodes -o wide
	```
3. List system pods:
	```sh
	kubectl get pods -n kube-system -o wide
	```
	- Observe the pods running in the `kube-system` namespace (e.g., CoreDNS, kube-proxy, metrics-server).

**Explanation:**
- System pods are essential for cluster operation and are scheduled on the system node pool.
- With Azure CNI, each pod receives an IP from the subnet.

---

## 3. Deploy a Sample Application (Deployment)

**Step-by-step:**
1. Deploy a simple NGINX application:
	```sh
	kubectl create deployment nginx --image=nginx --replicas=2
	```
2. Expose the deployment as a service:
	```sh
	kubectl expose deployment nginx --port=80 --type=LoadBalancer
	```
3. Check the pods:
	```sh
	kubectl get pods -o wide
	```

**Explanation:**
- Each NGINX pod will be assigned an IP from the Azure subnet.
- The LoadBalancer service will provision an Azure public IP for external access.

---

## 4. Check the Pod IPs and Co-relate with Connected Devices on Subnet

**Step-by-step:**
1. List pod IPs:
	```sh
	kubectl get pods -o wide
	```
	- Note the `IP` column for each pod.
2. In the Azure Portal, navigate to the subnet used by your AKS node pool.
3. View the list of connected devices/IPs in the subnet (e.g., via the subnet's "Connected devices" blade).
4. Match the pod IPs from `kubectl` output with the IPs shown in the Azure Portal.

**Explanation:**
- With Azure CNI, pod IPs are first-class citizens in the VNet and are visible as connected devices.
- This enables direct communication between pods and other Azure resources (VMs, databases, etc.) without NAT.

---

## Best Practices and Next Steps

- Always plan subnet size to accommodate expected pod growth.
- Use network policies to restrict traffic between pods for security.
- Clean up resources after the demo:
  ```sh
  az group delete --name aks-cni-demo-rg
  ```
