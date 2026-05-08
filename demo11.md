# Hands-On Guide: Testing Azure RBAC in AKS Cluster

## Prerequisites
- Azure CLI installed and logged in.
- Sufficient permissions to create and manage Azure resources.
- An existing Azure subscription.

---

```bash
# VARIABLES
RESOURCE_GROUP=aks-demorg
AKS_CLUSTER=aks31565
LOCATION=eastus
```


## Step 1: Deploy an AKS Cluster with Azure RBAC Enabled
```bash
az aks create --resource-group $RESOURCE_GROUP --name $AKS_CLUSTER --enable-aad  --enable-azure-rbac --node-count 1 --generate-ssh-keys --node-vm-size 'Standard_d2s_v6'
```


---

## Step 2: Create a New Entra ID Service Principal
```bash
az ad sp create-for-rbac --name dev1
```
Note down the `appId` and `password` from the output.

---

## Step 3: Assign AKS Cluster Admin Role to Current User
```bash
az role assignment create \
  --assignee $(az ad signed-in-user show --query id -o tsv) \
  --role "Azure Kubernetes Service RBAC Cluster Admin" \
  --scope $(az aks show --resource-group <resource-group-name> --name <aks-cluster-name> --query id -o tsv)
```

---

## Step 4: Assign AKS Cluster User Role to the Service Principal
```bash
az role assignment create \
  --assignee <appId-of-dev1> \
  --role "Azure Kubernetes Service RBAC Reader" \
  --scope $(az aks show --resource-group <resource-group-name> --name <aks-cluster-name> --query id -o tsv)
```
Replace `<appId-of-dev1>` with the `appId` of the service principal created in Step 2.

---

## Step 5: Login as Cluster Admin and Download AKS Credentials
```bash
az aks get-credentials \
  --resource-group <resource-group-name> \
  --name <aks-cluster-name>
```
This command configures `kubectl` to use the current user's credentials.

---

## Step 6: Create Kubernetes Role and RoleBinding
Create a role to restrict `dev1` from performing create operations:

```yaml
# role.yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: default
  name: restricted-role
rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["get", "list"]
```

Apply the role:
```bash
kubectl apply -f role.yaml
```

Create a role binding for `dev1`:
```yaml
# rolebinding.yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: restricted-binding
  namespace: default
subjects:
- kind: User
  name: <appId-of-dev1>
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: Role
  name: restricted-role
  apiGroup: rbac.authorization.k8s.io
```

Apply the role binding:
```bash
kubectl apply -f rolebinding.yaml
```

---

## Step 7: Test Access as Cluster Admin
Run the following commands to verify access:
```bash
kubectl get pods
kubectl create pod test-pod --image=nginx
kubectl delete pod test-pod
```

---

## Step 8: Login as Service Principal `dev1`
```bash
az login --service-principal \
  --username <appId-of-dev1> \
  --password <password-of-dev1> \
  --tenant <tenant-id>
```
Replace `<appId-of-dev1>`, `<password-of-dev1>`, and `<tenant-id>` with the values from Step 2.

---

## Step 9: Test Access as `dev1`
Run the following commands to verify restricted access:
```bash
kubectl get pods
kubectl create pod test-pod --image=nginx
kubectl delete pod test-pod
```
You should only be able to list pods and not create or delete them.

---

## Step 10: Cleanup Resources
To clean up the resources created during this guide:
```bash
az group delete --name <resource-group-name> --yes --no-wait
```
