# AKS Integration with Key Vault

## Overview of ConfigMap and Secrets
ConfigMaps and Secrets are Kubernetes resources used to manage configuration data and sensitive information, respectively. 

- **ConfigMap**: Stores non-sensitive configuration data in key-value pairs.
- **Secret**: Stores sensitive data such as passwords, tokens, and keys in a base64-encoded format.

These resources allow you to decouple configuration and sensitive data from application code, making it easier to manage and secure.

## Injecting ConfigMap and Secrets as Environment Variables
You can inject ConfigMap and Secret values into a pod as environment variables. This approach is useful for applications that expect configuration data as environment variables.

### Example Pod
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: example-pod
spec:
  containers:
  - name: example-container
    image: nginx
    env:
    - name: CONFIG_VALUE
      valueFrom:
        configMapKeyRef:
          name: example-configmap
          key: config-key
    - name: SECRET_VALUE
      valueFrom:
        secretKeyRef:
          name: example-secret
          key: secret-key
```

## Injecting ConfigMap and Secret as Read-Only Volume
Another way to use ConfigMaps and Secrets is by mounting them as read-only volumes. This approach is useful for applications that expect configuration data as files.

### Example Pod
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: example-pod
spec:
  containers:
  - name: example-container
    image: nginx
    volumeMounts:
    - name: config-volume
      mountPath: /etc/config
      readOnly: true
    - name: secret-volume
      mountPath: /etc/secret
      readOnly: true
  volumes:
  - name: config-volume
    configMap:
      name: example-configmap
  - name: secret-volume
    secret:
      secretName: example-secret
```

## Overview of Key Vault
Azure Key Vault is a cloud service for securely storing and accessing secrets, keys, and certificates. It provides:

- Centralized secret management
- Secure access control
- Integration with Azure services

Key Vault helps ensure that sensitive information is stored securely and accessed only by authorized applications and users.

## How Key Vault Integration Works in AKS (CSI Drivers)
The Azure Key Vault Provider for Secrets Store CSI Driver allows AKS pods to access secrets stored in Azure Key Vault. The CSI driver mounts Key Vault secrets as volumes inside pods, enabling seamless integration.

### Key Features
- Securely fetch secrets from Key Vault
- Automatic rotation of secrets
- Support for multiple Key Vaults

## Azure CLI Commands to Create Key Vault and Integrate with AKS Cluster
Follow these steps to set up Key Vault and integrate it with your AKS cluster:

1. **Create a Key Vault**:
   ```bash
   az keyvault create --name <KeyVaultName> --resource-group <ResourceGroupName> --location <Location>
   ```

2. **Enable Key Vault Integration in AKS**:
   ```bash
   az aks enable-addons --addons azure-keyvault-secrets-provider --name <AKSClusterName> --resource-group <ResourceGroupName>
   ```

3. **Grant AKS Access to Key Vault**:
   ```bash
   az keyvault set-policy --name <KeyVaultName> --resource-group <ResourceGroupName> --secret-permissions get list --spn <AKSServicePrincipalID>
   ```

## Deploy Secret to Key Vault
To store a secret in Key Vault, use the following command:
```bash
az keyvault secret set --vault-name <KeyVaultName> --name <SecretName> --value <SecretValue>
```

## Access Secrets from Key Vault into Pods in AKS
To access secrets from Key Vault in your AKS pods, follow these steps:

1. **Create a SecretProviderClass**:
   ```yaml
   apiVersion: secrets-store.csi.x-k8s.io/v1
   kind: SecretProviderClass
   metadata:
     name: azure-keyvault-provider
   spec:
     provider: azure
     parameters:
       usePodIdentity: "false"
       keyvaultName: <KeyVaultName>
       cloudName: "AzurePublicCloud"
       objects: |
         array:
           - |
             objectName: <SecretName>
             objectType: secret
       tenantId: <TenantID>
   ```

2. **Deploy a Pod with Key Vault Integration**:
   ```yaml
   apiVersion: v1
   kind: Pod
   metadata:
     name: example-pod
   spec:
     containers:
     - name: example-container
       image: nginx
       volumeMounts:
       - name: secrets-store-inline
         mountPath: "/mnt/secrets-store"
         readOnly: true
     volumes:
     - name: secrets-store-inline
       csi:
         driver: secrets-store.csi.k8s.io
         readOnly: true
         volumeAttributes:
           secretProviderClass: azure-keyvault-provider
   ```

This configuration mounts the Key Vault secret as a file in the pod at `/mnt/secrets-store`.

---

By following this guide, the AKS Operations Team can effectively manage and integrate Azure Key Vault with AKS, ensuring secure and efficient handling of sensitive data.