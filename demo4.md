
# Resource Quotas for Namespaces in Shared AKS Clusters

This learning module covers how to manage resources in a shared Azure Kubernetes Service (AKS) cluster using namespaces and resource quotas. By the end, you will understand how to isolate teams or environments and control their resource consumption.

## Learning Objectives

- Understand the purpose of namespaces and resource quotas in Kubernetes
- Learn how to deploy a public AKS cluster
- Create namespaces for teams or environments
- Apply and manage resource quotas
- Monitor and adjust quotas based on usage

---

## 1. Deploy a Public AKS Cluster with a Single Node

**Purpose:** To provide a shared Kubernetes environment for multiple teams or environments, while keeping costs low for learning or testing.

**Steps:**
1. Log in to Azure:
  ```sh
  az login
  ```
2. Create a resource group:
  ```sh
  az group create --name aks-demo-rg --location eastus
  ```
3. Deploy an AKS cluster with a single node:
  ```sh
  az aks create --resource-group aks-demo-rg --name aks-demo-cluster --node-count 1 --enable-addons monitoring --generate-ssh-keys
  ```
4. Get AKS credentials:
  ```sh
  az aks get-credentials --resource-group aks-demo-rg --name aks-demo-cluster
  ```

---

## 2. Create a Namespace for Each Team or Environment

**Purpose:** Namespaces logically isolate resources for different teams or environments within the same cluster.

**Example:**
```sh
kubectl create namespace dev
kubectl create namespace qa
kubectl create namespace prod
```

**Tip:** Use meaningful names for namespaces to reflect their purpose (e.g., `dev`, `qa`, `prod`, or team names).

---

## 3. Create Resource Quotas for Each Namespace

**Purpose:** Resource quotas prevent any single team or environment from consuming excessive cluster resources, ensuring fair usage.

**How it works:**
A `ResourceQuota` object sets hard limits on resources like CPU, memory, and number of pods within a namespace.

---

## 4. Resource Quota Example

Below is a sample `ResourceQuota` manifest for the `dev` namespace:

```yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: quota
  namespace: dev
spec:
  hard:
    pods: "4"
    limits.cpu: "2"
    limits.memory: "512Mi"
```

**Explanation:**
- Limits the number of pods to 4
- CPU limits to 2 CPUs
- Memory limits to 512Mi


---

## 5. Apply the ResourceQuota to the Namespace

1. Save the above YAML as `resource-quota.yaml`.
2. Apply it to the cluster:
  ```sh
  kubectl apply -f resource-quota.yaml
  ```
3. Repeat for each namespace, adjusting values as needed.

---

## 6. Monitor Resource Usage in Each Namespace

To check current usage and remaining quota:
```sh
kubectl describe quota -n <namespace>
```
Replace `<namespace>` with the actual namespace name (e.g., `dev`).

**Sample Output:**
```
Name:                   dev-quota
Namespace:              dev
Resource                Used  Hard
--------                ----  ----
pods                    1     4
requests.cpu            100m  500m
requests.memory         128Mi 512Mi
limits.cpu              200m  2
limits.memory           256Mi 4Gi
```

---

## 7. Adjust Resource Quotas as Needed

Monitor usage regularly. If a team needs more resources, update the quota YAML and re-apply:
```sh
kubectl apply -f resource-quota.yaml
```

**Best Practices:**
- Start with conservative limits and increase as justified by usage
- Communicate quota policies to all teams
- Use monitoring tools (e.g., Azure Monitor, kubectl top) for deeper insights

---

## Summary

By using namespaces and resource quotas, you can efficiently share a single AKS cluster among multiple teams or environments, ensuring fair resource allocation and cost control. Regularly review and adjust quotas to match evolving needs.

