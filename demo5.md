# Deploy AKS cluster using ARM Template

1. Create a new file `azuredeploy.json`
2. Add following lines of code

```JSON
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "nodeCount": {
            "type": "int",
            "defaultValue": 2,
            "metadata": {
                "description": "The number of nodes in the agent pool."
            }
        },
        "osType": {
            "type": "string",
            "defaultValue": "Linux",
            "allowedValues": [
                "Linux",
                "Windows"
            ],
            "metadata": {
                "description": "The OS type for the agent pool nodes."
            }
        }
    },
    "functions": [],
    "variables": {},
    "resources": [
        {
            "name": "aks3564f6",
            "type": "Microsoft.ContainerService/managedClusters",
            "apiVersion": "2024-08-01",
            "location": "[resourceGroup().location]",
            "identity": {
                    "type": "SystemAssigned"
            },
            "properties": {
                "kubernetesVersion": "1.34.4",
                "dnsPrefix": "dnsprefix",
                "agentPoolProfiles": [
                    {
                        "name": "agentpool",
                        "count": "[parameters('nodeCount')]",
                        "vmSize": "Standard_D2s_v6",
                        "osType": "[parameters('osType')]",
                        "mode": "System"

                    }
                ]
            }
        }
    ],
    "outputs": {}
}
```

3. Deploy using Azure CLI

```sh
az group create --name demo1 -l centralindia
az group deployment create --name aks1 -g demo1 --template-file .\azuredeploy.json 
```

4. Login into Azure portal and search for Kubernetes service, check status of cluster.