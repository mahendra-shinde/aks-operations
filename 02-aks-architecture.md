# AKS Reference Architecture: Learning Material

This module provides an in-depth understanding of Azure Kubernetes Service (AKS) architecture and best practices for designing, deploying, and operating AKS clusters in enterprise environments. Each section builds on the outline to give you practical knowledge and hands-on guidance.

---


## 1. AKS Architecture

Azure Kubernetes Service (AKS) provides a fully managed Kubernetes control plane, reducing operational overhead and allowing teams to focus on application development and deployment. The architecture separates the management responsibilities between Azure (control plane) and the customer (node pools and workloads).

**Key Components:**
- **Control Plane:**
	- Managed by Azure, includes the Kubernetes API server, etcd (cluster state), scheduler, and controller manager.
	- Azure ensures high availability, automatic patching, and upgrades.
	- Integrated with Azure monitoring and logging (Azure Monitor, Log Analytics).
- **Node Pools:**
	- One or more groups of VMs (nodes) that run your application pods.
	- Can mix VM sizes, OS types (Linux/Windows), and scale independently.
	- System node pool is required for critical system pods; user node pools for workloads.
- **Networking:**
	- Integrates with Azure Virtual Network (VNet) for secure, private communication.
	- Supports both kubenet and Azure CNI for pod networking.
	- Enables advanced features like network policies, private endpoints, and service endpoints.

**Benefits:**
- Simplified operations: Azure manages the control plane, upgrades, and security patches.
- Integrated security: RBAC, Azure AD integration, and network policies.
- Scalability: Easily scale node pools and workloads as needed.
- Cost efficiency: Pay only for agent nodes; control plane is free.

**Best Practice:**
- Use managed identities for secure access to Azure resources.
- Enable monitoring and logging for visibility and troubleshooting.

---


## 2. Cluster Creation Methods

There are several ways to create and manage AKS clusters, each suited to different scenarios:

- **Azure Portal:**
	- Provides a graphical interface for quick, manual cluster creation.
	- Good for learning, demos, and small-scale deployments.
- **Azure CLI:**
	- Enables scripting and automation for repeatable deployments.
	- Integrates well with CI/CD pipelines (e.g., Azure DevOps, GitHub Actions).
	- Example:
		```sh
		az aks create --resource-group my-rg --name my-aks --node-count 3 --enable-managed-identity --generate-ssh-keys
		```
- **ARM/Bicep Templates:**
	- Infrastructure as Code (IaC) for declarative, version-controlled deployments.
	- Supports parameterization and modularization for complex environments.
- **Terraform:**
	- Popular open-source IaC tool, supports multi-cloud and advanced automation.
	- Enables state management and collaboration.

**Best Practice:**
- Use IaC (Bicep, ARM, Terraform) for production to ensure consistency and traceability.
- Store templates in source control and automate deployments with CI/CD.

---


## 3. Node-Pools and Node Types

Node pools provide flexibility and efficiency in managing workloads with different requirements:

- **System Node Pool:**
	- Hosts critical system pods (CoreDNS, kube-proxy, metrics-server).
	- Should use reliable VM sizes and be highly available.
- **User Node Pools:**
	- Run application workloads; can be Linux or Windows.
	- Can use GPU-enabled VMs for ML/AI, or spot VMs for cost savings.
	- Can be tainted to restrict certain workloads.

**Scaling:**
- Node pools can be scaled independently (manual or autoscaler).
- Cluster Autoscaler automatically adjusts node count based on pending pods.

**Best Practice:**
- Separate system and user workloads for reliability.
- Use node labels and taints to control pod scheduling.

---


## 4. Public Clusters with Whitelisted IPs

By default, AKS exposes the Kubernetes API server with a public IP address. This allows management from anywhere, but increases the attack surface.

**Securing Public Clusters:**
- Restrict API server access to trusted IP ranges using `--api-server-authorized-ip-ranges`.
- Regularly review and update the allowed IPs.
- Monitor API server access logs for suspicious activity.

**Example:**
```sh
az aks create --resource-group my-rg --name my-aks --api-server-authorized-ip-ranges 203.0.113.0/24
```

**Best Practice:**
- Use public clusters only for dev/test or when absolutely necessary.
- Always restrict access to known IPs and enable RBAC.

---

## 5. Private Clusters

Private AKS clusters provide maximum security by ensuring the API server is only accessible from within the Azure VNet. There is no public endpoint, reducing the risk of unauthorized access.

**Benefits:**
- No exposure to the public internet.
- Meets compliance and regulatory requirements.
- Enables integration with private endpoints and on-premises networks.

**Considerations:**
- Requires a jumpbox, VPN, or ExpressRoute for management access.
- More complex to set up and manage, but essential for production.

**Best Practice:**
- Use private clusters for production and sensitive workloads.
- Combine with Azure AD, RBAC, and network policies for defense in depth.

---


## 6. Accessing Private Cluster from Cloud Shell

Azure Cloud Shell is a browser-based shell with Azure CLI and kubectl pre-installed. By default, it runs in a Microsoft-managed VNet, so it cannot access private AKS clusters unless:

- Cloud Shell is configured to use a custom VNet (requires setup in Azure Portal).
- Alternatively, use a jumpbox VM in the same VNet as the AKS cluster, SSH into it, and use Azure CLI/kubectl from there.

**Best Practice:**
- For production, prefer jumpbox or VPN for secure, auditable access.

---


## 7. Accessing Private Cluster from Jumpbox

A **jumpbox** (bastion host) is a VM deployed in the same VNet/subnet as the AKS cluster, used as a secure entry point for management.

**Steps:**
1. Deploy a Linux VM (e.g., Ubuntu) in the AKS VNet and subnet.
2. Install Azure CLI and kubectl:
	```sh
	sudo apt update && sudo apt install -y azure-cli
	curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
	chmod +x kubectl && sudo mv kubectl /usr/local/bin/
	```
3. Use managed identity or Azure credentials to authenticate:
	```sh
	az login --identity
	```
4. Run `az aks get-credentials` to configure kubectl access:
	```sh
	az aks get-credentials --resource-group <aks-rg> --name <aks-cluster>
	kubectl get nodes
	```

**Best Practice:**
- Restrict jumpbox access with NSGs and just-in-time (JIT) VM access.
- Use managed identity for least-privilege authentication.



## 8. Azure CNI (IP Planning Challenges)

Azure CNI (Container Networking Interface) provides advanced networking for AKS by assigning each pod an IP address from the Azure VNet subnet. This enables:

- Direct connectivity between pods and Azure resources (e.g., databases, firewalls).
- Support for network policies, private endpoints, and service endpoints.

**IP Planning Challenges:**
- Each pod consumes a VNet IP, so large clusters require large subnets (e.g., /22 or larger).
- Subnet exhaustion can occur if not planned properly, especially with autoscaling.
- Consider using multiple subnets or larger address spaces for future growth.

**Tip:** Use the [Azure subnet calculator](https://docs.microsoft.com/en-us/azure/virtual-network/ip-services/subnet-calculator) for planning.

**Best Practice:**
- Regularly review subnet usage and adjust as needed.
- Use network policies to restrict traffic between pods and services.

---


## 8a. Kubenet vs Azure CNI: Comparison

AKS supports two main network plugins: **kubenet** and **Azure CNI**. The choice affects scalability, network features, and integration with Azure resources.

| Feature                | Kubenet                                      | Azure CNI                                      |
|------------------------|----------------------------------------------|------------------------------------------------|
| Pod IP Assignment      | NAT from node subnet (private IPs)           | Directly from VNet subnet (real Azure IPs)     |
| Network Integration    | Basic, limited to node subnet                | Full VNet integration, peering, firewalls      |
| NSG/Firewall Support   | Node-level only                              | Pod-level (fine-grained control)               |
| Max Pods per Node      | Up to 110 (default), can be higher           | Limited by subnet size (usually lower)         |
| Performance            | Slightly better (less overhead)              | Slightly lower (more features, more overhead)  |
| Use Case               | Dev/test, simple workloads                   | Production, enterprise, advanced networking    |
| IP Consumption         | Fewer IPs needed (NAT)                       | Each pod uses a VNet IP (plan for exhaustion)  |

**Kubenet:**
- Simpler, uses NAT for pod traffic (pods share node IP, outgoing traffic is SNATed).
- Good for small clusters, dev/test, or when IP space is limited.
- Less integration with Azure networking features (no direct peering, limited NSG support).
- Cannot use Azure Private Link or advanced network policies.

**Azure CNI:**
- Each pod gets a real Azure VNet IP, enabling advanced networking (firewalls, peering, private endpoints).
- Required for production, security, and compliance scenarios.
- Enables pod-level NSGs, Azure Firewall, and integration with on-premises networks.
- Needs careful subnet/IP planning to avoid exhaustion.

**Summary:**
- Use **kubenet** for simple, cost-effective clusters with basic networking needs.
- Use **Azure CNI** for enterprise, production, or when you need full Azure networking integration and security.

---


## 9. Hub–Spoke Networking Model

The hub-spoke model is a widely used enterprise network topology for organizing and securing cloud resources:

- **Hub:**
	- Central VNet hosting shared services (firewalls, DNS, jumpboxes, monitoring).
	- Acts as a gateway to on-premises networks via VPN or ExpressRoute.
- **Spokes:**
	- Separate VNets for individual workloads (e.g., AKS clusters, app services).
	- Peered with the hub for secure, controlled access to shared resources.

**Benefits:**
- Centralized control of network traffic and security policies.
- Improved security by isolating workloads in separate spokes.
- Simplified management and compliance.

**Best Practice:**
- Use network security groups (NSGs) and Azure Firewall in the hub for traffic filtering.
- Peer only required spokes to the hub to minimize attack surface.

---


## 10. Private DNS Zones

Private DNS zones provide internal name resolution for Azure resources, essential for private AKS clusters and hybrid environments.

**Use Cases in AKS:**
- Resolving internal service names (e.g., myservice.default.svc.cluster.local).
- Enabling API server access in private clusters (e.g., <clustername>-hcp.<region>.azmk8s.io).
- Supporting hybrid and multi-region deployments with consistent DNS.

**Integration:**
- Use Azure Private DNS Zones and link them to VNets for seamless connectivity.
- Automatically configured for private AKS clusters, but can be customized.

**Best Practice:**
- Use Private DNS Zones for all private and hybrid AKS deployments.
- Regularly review DNS records and VNet links for accuracy.

---


## 11. Control Plane Isolation Concepts

AKS provides several features to isolate and secure the control plane and cluster access:

- **Private Clusters:**
	- API server is only accessible from within the VNet (no public endpoint).
	- Reduces risk of external attacks.
- **Network Policies:**
	- Restrict traffic between pods, namespaces, and services.
	- Supported with Azure CNI and Calico network policy engine.
- **RBAC (Role-Based Access Control):**
	- Fine-grained access control for users, groups, and service accounts.
	- Integrates with Azure AD for centralized identity management.
- **API Server VNet Integration:**
	- Ensures all management traffic stays within the Azure backbone network.

**Best Practice:**
- Always enable RBAC and network policies for production clusters.
- Use private clusters and VNet integration for sensitive workloads.

---


## 12. Multi-Environment Design (Dev/Test/Prod)

Designing for multiple environments ensures isolation, security, and compliance across the application lifecycle:

- **Separate Resource Groups and VNets:**
	- Isolate Dev, Test, and Prod environments to prevent accidental cross-environment access.
	- Apply different policies, quotas, and monitoring settings per environment.
- **Infrastructure as Code (IaC):**
	- Use Bicep, ARM, or Terraform to automate and version deployments.
	- Enables consistent, repeatable environments.
- **RBAC and Policies:**
	- Apply environment-specific RBAC roles and Azure Policies for governance.
	- Limit access to production clusters to only essential personnel.
- **CI/CD Integration:**
	- Automate deployments and testing for each environment.
	- Use separate pipelines and secrets for each stage.

**Best Practice:**
- Regularly review and audit access, policies, and resource usage in each environment.
- Use tagging and naming conventions for easy identification and management.

---

## Summary

This expanded module provides detailed guidance on AKS architecture, networking, security, and operational best practices. Use the hands-on demos and guides to reinforce your understanding and gain practical experience with AKS in real-world scenarios.
