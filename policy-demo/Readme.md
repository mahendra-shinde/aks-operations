# Network Policy

## Overview
Network policies in Kubernetes allow you to control the traffic flow between pods and other network endpoints. This document provides a step-by-step guide for the AKS Operations Team to manage and test network policies effectively.

## Prerequisites
Before you begin, ensure the following:
- Access to an Azure Kubernetes Service (AKS) cluster.
- Kubernetes CLI (`kubectl`) installed and configured.
- Basic understanding of Kubernetes pods and networking.

## Steps to Implement and Test Network Policies

### 1. Create a Cluster with Network Policy Type 'Calico'
Calico is a popular choice for implementing network policies in Kubernetes. To create a cluster with Calico as the network policy provider:

1. Use the Azure CLI to create the cluster:
   ```bash
   az aks create --resource-group <ResourceGroupName> --name <ClusterName> --network-policy calico
   ```
2. Verify the cluster creation:
   ```bash
   az aks show --resource-group <ResourceGroupName> --name <ClusterName>
   ```

### 2. Connect to the New Cluster
Once the cluster is created, connect to it using `kubectl`:

```bash
az aks get-credentials --resource-group <ResourceGroupName> --name <ClusterName>
```

Verify the connection:
```bash
kubectl get nodes
```

### 3. Deploy Two Pods Using `app.yaml` File
The `app.yaml` file contains the configuration for two pods. Deploy the pods:

```bash
kubectl apply -f app.yaml
```

Verify the pods are running:
```bash
kubectl get pods
```

### 4. Deploy Network Policy Using `policy.yaml` File
The `policy.yaml` file defines the network policy to restrict traffic between the pods. Apply the policy:

```bash
kubectl apply -f policy.yaml
```

Verify the policy is applied:
```bash
kubectl get networkpolicy
```

### 5. Test Sending HTTP Requests Between Pods

#### Test 1: From Pod1 to Pod2 (Expected: SUCCESS)
1. Get the name of Pod1:
   ```bash
   kubectl get pods
   ```
2. Execute an HTTP request from Pod1 to Pod2:
   ```bash
   kubectl exec <Pod1Name> -- curl <Pod2IP>:<Port>
   ```

#### Test 2: From Pod2 to Pod1 (Expected: FOREVER WAIT)
1. Get the name of Pod2:
   ```bash
   kubectl get pods
   ```
2. Execute an HTTP request from Pod2 to Pod1:
   ```bash
   kubectl exec <Pod2Name> -- curl <Pod1IP>:<Port>
   ```

### 6. Delete the Policy and Repeat the Tests
To observe the effect of removing the network policy:

1. Delete the policy:
   ```bash
   kubectl delete -f policy.yaml
   ```
2. Repeat the HTTP request tests from Pod1 to Pod2 and Pod2 to Pod1. Both should succeed now.

### 7. Delete the Cluster
Once testing is complete, delete the cluster to avoid unnecessary costs:

```bash
az aks delete --resource-group <ResourceGroupName> --name <ClusterName> --yes
```

## Summary
This guide demonstrates how to create and test network policies in an AKS cluster. By following these steps, the AKS Operations Team can ensure secure and controlled communication between pods in the cluster.
