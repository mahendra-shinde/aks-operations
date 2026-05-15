# Cluster Operations

## Cluster Health Checks
Cluster health checks are essential to ensure the stability and reliability of your AKS cluster. Regular health checks help identify and resolve issues before they impact workloads.

### Key Actions:
- **Check Cluster Status:** Use the Azure CLI to verify the overall health of the cluster:
  ```bash
  az aks show --resource-group <ResourceGroupName> --name <ClusterName>
  ```
- **Inspect Node Conditions:** Use `kubectl` to check the status of nodes:
  ```bash
  kubectl get nodes
  ```
  Look for conditions like `Ready`, `NotReady`, or `Unknown`.
- **Review Control Plane Logs:** Use Azure Monitor or Log Analytics to review logs for the API server, scheduler, and other control plane components.

## Node Readiness & Pressure Conditions
Node readiness and pressure conditions directly impact the ability of the cluster to schedule and run workloads.

### Key Actions:
- **Monitor Node Readiness:**
  ```bash
  kubectl describe node <NodeName>
  ```
  Check for `Ready` status and any taints that might affect scheduling.
- **Identify Pressure Conditions:** Look for `MemoryPressure`, `DiskPressure`, or `PIDPressure` in node conditions.
- **Mitigation Steps:**
  - Scale the cluster to add more nodes.
  - Optimize workloads to reduce resource consumption.
  - Use Azure Advisor recommendations for resource optimization.

## Resource Exhaustion Scenarios
Resource exhaustion can lead to degraded performance or downtime.

### Key Actions:
- **Monitor Resource Usage:** Use Azure Monitor to track CPU, memory, and disk usage.
- **Set Resource Requests and Limits:** Ensure pods have appropriate resource requests and limits defined in their manifests.
- **Enable Cluster Autoscaler:** Automatically scale the cluster based on workload demands.

## Incident Scenarios

### Node NotReady
A `Node NotReady` condition indicates that a node is unavailable for scheduling.

#### Troubleshooting Steps:
1. **Check Node Status:**
   ```bash
   kubectl get nodes
   ```
2. **Inspect Node Events:**
   ```bash
   kubectl describe node <NodeName>
   ```
3. **Review Logs:** Check kubelet and system logs on the node for errors.
4. **Mitigation:** Restart the node or cordon and drain it if necessary.

### Pod CrashLoopBackOff
A `CrashLoopBackOff` status indicates that a pod is repeatedly failing to start.

#### Troubleshooting Steps:
1. **Inspect Pod Logs:**
   ```bash
   kubectl logs <PodName>
   ```
2. **Describe the Pod:**
   ```bash
   kubectl describe pod <PodName>
   ```
3. **Check Resource Limits:** Ensure the pod has sufficient resources.
4. **Mitigation:** Fix application errors, adjust resource limits, or redeploy the pod.

### API Server Latency
High API server latency can affect the responsiveness of the cluster.

#### Troubleshooting Steps:
1. **Monitor API Server Metrics:** Use Azure Monitor to track API server performance.
2. **Check Network Latency:** Ensure there are no network issues affecting the control plane.
3. **Mitigation:** Scale the control plane or optimize workloads to reduce API server load.

## Security & Compliance

### Azure RBAC vs Kubernetes RBAC Deep Dive
- **Azure RBAC:** Manages access to Azure resources, including AKS.
- **Kubernetes RBAC:** Manages access within the Kubernetes cluster.
- **Best Practices:**
  - Use Azure AD integration for centralized identity management.
  - Define fine-grained roles and bindings in Kubernetes.

### Least Privilege Design Patterns
- **Principle of Least Privilege:** Grant only the permissions necessary for a role.
- **Implementation:**
  - Use `Role` and `RoleBinding` for namespace-scoped permissions.
  - Use `ClusterRole` and `ClusterRoleBinding` for cluster-wide permissions.

### Audit & Logging Expectations
- **Enable Audit Logs:** Use Azure Policy to enforce audit logging.
- **Review Logs Regularly:** Use Log Analytics to query and analyze logs.
- **Compliance Checks:** Use Azure Security Center to ensure compliance with standards.

## Monitoring & SRE Practices

### Using Azure Monitor
Azure Monitor provides a comprehensive solution for monitoring AKS clusters.

#### Key Features:
- Metrics and logs collection.
- Alerts and notifications.
- Integration with Grafana and other tools.

### What to Monitor

#### Control Plane Signals
- API server health.
- Scheduler performance.
- Controller manager logs.

#### Node Health
- Node readiness and pressure conditions.
- Resource utilization (CPU, memory, disk).

#### Workload Metrics
- Pod status and restarts.
- Application-specific metrics.
- Horizontal Pod Autoscaler (HPA) metrics.

