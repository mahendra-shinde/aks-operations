# Hands-On Lab: Demonstrating AppRouting Addon for AKS

## Prerequisites
- An existing AKS cluster.
- Azure CLI installed and authenticated.
- Kubernetes CLI (`kubectl`) installed and configured to access the AKS cluster.

---

## Step 1: Enable the AppRouting Addon
The AppRouting addon simplifies ingress and DNS management for AKS clusters. Use the following Azure CLI command to enable the addon:

```bash
az aks approuting enable -n <AKS-Cluster-Name> -g <Resource-Group-Name>
```

Replace `<AKS-Cluster-Name>` with your AKS cluster name and `<Resource-Group-Name>` with the resource group containing the cluster.

Verify that the addon is enabled:

```bash
az aks show --name <AKS-Cluster-Name> --resource-group <Resource-Group-Name> --query "addonProfiles.ingressAppGw.enabled"
```

The output should return `true`.

---

## Step 2: Deploy the Application
The `deploy.yaml` file contains the deployment and service definitions for three sample web applications (`webapp1`, `webapp2`, and `webapp3`).

### Explanation of `deploy.yaml`
- **Deployments**: Each deployment creates a pod running a specific version of the `mahendrshinde/web` container image.
  - `webapp1`: Uses `mahendrshinde/web:1`.
  - `webapp2`: Uses `mahendrshinde/web:2`.
  - `webapp3`: Uses `mahendrshinde/web:3`.
- **Services**: Each deployment is exposed via a Kubernetes `Service` on port 80.

### Deploy the Resources
Run the following command to deploy the resources:

```bash
kubectl apply -f deploy.yaml
```

Verify the deployments and services:

```bash
kubectl get deployments
kubectl get services
```

---

## Step 3: Configure Ingress Routes
The `approutes.yaml` file defines ingress routes for the deployed applications.

### Explanation of `approutes.yaml`
- **Ingress Resource**: Configures routing rules for the applications.
  - `/webapp1(.*)`: Routes traffic to `webapp1-svc`.
  - `/webapp2(.*)`: Routes traffic to `webapp2-svc`.
  - `/webapp3(.*)`: Routes traffic to `webapp3-svc`.
- **Annotations**: Includes `nginx.ingress.kubernetes.io/rewrite-target` to rewrite the URL path.
- **Ingress Class**: Uses `webapprouting.kubernetes.azure.com` to integrate with the AppRouting addon.

### Apply the Ingress Configuration
Run the following command to apply the ingress configuration:

```bash
kubectl apply -f approutes.yaml
```

Verify the ingress resource:

```bash
kubectl get ingress
```

---

## Step 4: Test the Application
1. Retrieve the external IP address of the ingress controller:

   ```bash
   kubectl get ingress
   ```

2. Access the applications in your browser using the following paths:
   - `http://<EXTERNAL-IP>/webapp1`
   - `http://<EXTERNAL-IP>/webapp2`
   - `http://<EXTERNAL-IP>/webapp3`

Replace `<EXTERNAL-IP>` with the external IP address retrieved in the previous step.

---

## Cleanup (Optional)
To delete the resources created during this lab, run:

```bash
kubectl delete -f approutes.yaml
kubectl delete -f deploy.yaml
```

To disable the AppRouting addon, run:

```bash
az aks approuting disable --name <AKS-Cluster-Name> --resource-group <Resource-Group-Name>
```