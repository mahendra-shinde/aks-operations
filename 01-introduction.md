# Introduction to Azure Kubernetes Services

Welcome to the learning module on Azure Kubernetes Services (AKS). This material will guide you through the foundational concepts of Kubernetes, its architecture, deployment models, and a focused introduction to AKS as a managed Kubernetes solution on Azure.

## Overview of Kubernetes

Kubernetes is an open-source platform designed to automate deploying, scaling, and operating application containers. It provides a robust framework for running distributed systems resiliently. Kubernetes manages the lifecycle of containerized applications across a cluster of machines, offering features such as service discovery, load balancing, storage orchestration, automated rollouts and rollbacks, and self-healing.

**Key Features:**
- Automated container deployment and management
- Horizontal scaling and load balancing
- Service discovery and DNS management
- Storage orchestration
- Self-healing (auto-restart, replication, rescheduling)
- Declarative configuration and automation

## Kubernetes Architecture

Kubernetes follows a master-worker architecture:

- **Control Plane (Master Components):**
	- `kube-apiserver`: Serves the Kubernetes API.
	- `etcd`: Consistent and highly-available key-value store for all cluster data.
	- `kube-scheduler`: Assigns workloads to worker nodes.
	- `kube-controller-manager`: Runs controller processes to regulate the state of the cluster.

- **Node Components (Workers):**
	- `kubelet`: Ensures containers are running in a Pod.
	- `kube-proxy`: Maintains network rules for Pod communication.
	- Container runtime (e.g., containerd, Docker): Runs containers.

**Cluster Objects:**
- **Pod:** Smallest deployable unit, encapsulates one or more containers.
- **Service:** Exposes a set of Pods as a network service.
- **Deployment:** Manages stateless applications, handles updates and rollbacks.
- **StatefulSet, DaemonSet, Job, CronJob:** Specialized controllers for different workloads.

## Managed vs Self Hosted Kubernetes

There are two main approaches to running Kubernetes:

- **Self-Hosted Kubernetes:**
	- You install, configure, and manage the Kubernetes control plane and nodes yourself (on-premises or in the cloud).
	- Offers maximum flexibility and control, but requires significant operational expertise.
	- You are responsible for upgrades, security patches, scaling, and high availability.

- **Managed Kubernetes:**
	- A cloud provider manages the control plane and often the worker nodes.
	- Reduces operational overhead, automates upgrades, scaling, and security.
	- Examples: Azure Kubernetes Service (AKS), Google Kubernetes Engine (GKE), Amazon Elastic Kubernetes Service (EKS).

## Overview of Azure Kubernetes Service

Azure Kubernetes Service (AKS) is Microsoft Azure's managed Kubernetes offering. It simplifies deploying a managed Kubernetes cluster in Azure by offloading much of the operational overhead to Azure:

- **Managed Control Plane:** Azure manages the Kubernetes masters, upgrades, and patches.
- **Integrated Azure Services:** Seamless integration with Azure Active Directory, monitoring, networking, and storage.
- **Scaling:** Easily scale node pools up or down based on demand.
- **Security:** Built-in security features, including RBAC, network policies, and integration with Azure security tools.
- **Cost Efficiency:** Pay only for the agent nodes (control plane is free).

**Typical Use Cases:**
- Microservices-based applications
- Batch processing and CI/CD pipelines
- Hybrid and multi-cloud workloads

In the following modules, you will learn how to deploy, operate, and troubleshoot AKS clusters, and best practices for running production workloads on Azure Kubernetes Service.

