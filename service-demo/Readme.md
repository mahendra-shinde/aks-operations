# Hands-On Lab: Deploying a Service in Kubernetes

## Objective
In this lab, you will learn how to deploy a Kubernetes service, scale a deployment, and test the service using a test pod. You will also understand the commands and parameters used in the process.

---

## Prerequisites
- A Kubernetes cluster is up and running.
- `kubectl` CLI is installed and configured to interact with your cluster.

---

## Steps

### Step 1: Deploy the Application with a Service
1. Apply the `app.yaml` manifest to deploy the application and its service:
   ```bash
   kubectl apply -f app.yaml
   ```
   **Explanation:**
   - `apply`: Used to create or update resources defined in a manifest file.
   - `-f app.yaml`: Specifies the manifest file to apply.

2. Verify that the pods are running:
   ```bash
   kubectl get pods
   ```
   **Explanation:**
   - `get pods`: Lists all pods in the current namespace.

---

### Step 2: Scale the Deployment
1. Scale the deployment to increase the number of replicas:
   ```bash
   kubectl scale deploy myapp --replicas=<number>
   ```
   Replace `<deployment-name>` with the name of your deployment and `<number>` with the desired number of replicas.

   **Explanation:**
   - `scale deployment`: Scales the specified deployment.
   - `--replicas`: Specifies the number of pod replicas to run.

2. Check the updated endpoints:
   ```bash
   kubectl get endpoints
   ```
   **Explanation:**
   - `get endpoints`: Displays the endpoints associated with services in the current namespace. (You may use shortcut 'ep' )

---

### Step 3: Deploy a Test Pod
1. Apply the `testpod.yaml` manifest to deploy a test pod:
   ```bash
   kubectl apply -f testpod.yaml
   ```
   **Explanation:**
   - `apply`: Creates or updates resources defined in the manifest file.
   - `-f testpod.yaml`: Specifies the manifest file for the test pod.

2. Use the test pod to test the service URL:
   ```bash
   kubectl exec -it testpod -- curl http://app1
   ```
   

   **Explanation:**
   - `exec`: Executes a command in a running pod.
   - `-it`: Enables interactive mode.
   - `curl http://app1`: Sends an HTTP request to the service URL.

---

### Step 4: Clean Up Resources
1. Delete the application and test pod:
   ```bash
   kubectl delete -f app.yaml
   kubectl delete -f testpod.yaml
   ```
   **Explanation:**
   - `delete`: Removes resources defined in the manifest file.
   - `-f`: Specifies the manifest file to delete.

---

## Summary
In this lab, you deployed an application with a service, scaled the deployment, and tested the service using a test pod. You also learned the `kubectl` commands and their parameters used in the process.