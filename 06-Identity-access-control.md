# Identity and Access Control for AKS Operations

This module provides AKS Operations teams with practical guidance on managing identity and access control in Azure Kubernetes Service (AKS). It covers the differences between Azure RBAC and Kubernetes RBAC, implementing least privilege, and segmenting access at the namespace level.

---

## 1. Azure RBAC vs Kubernetes RBAC

**Overview:**
AKS integrates with both Azure Role-Based Access Control (RBAC) and Kubernetes RBAC. Understanding the distinction and interplay between these systems is critical for secure cluster operations.

**Azure RBAC:**
- Controls access to Azure resources (e.g., AKS cluster, node pools, ACR, networking) via Azure Active Directory identities.
- Assigns roles at the subscription, resource group, or resource level.
- Used for cluster-level actions (e.g., get-credentials, scaling, upgrades).

**Kubernetes RBAC:**
- Controls access within the Kubernetes cluster (e.g., pods, deployments, services).
- Uses Roles and RoleBindings (or ClusterRoles/ClusterRoleBindings) to grant permissions to users, groups, or service accounts.
- Enforced by the Kubernetes API server.

**Operational Guidance:**
- Use Azure RBAC for managing who can access and operate the AKS cluster itself.
- Use Kubernetes RBAC for controlling access to workloads and resources inside the cluster.
- Document and regularly review both Azure and Kubernetes RBAC assignments.

---

## 2. Least Privilege Access Model

**Overview:**
The principle of least privilege ensures users and services have only the permissions they need to perform their tasks—nothing more. This reduces the risk of accidental or malicious actions.

**Best Practices:**
- Grant access based on job roles and responsibilities.
- Use built-in roles where possible; create custom roles only when necessary.
- Regularly audit role assignments and remove unnecessary permissions.
- Use Azure AD groups to manage user access at scale.
- Prefer short-lived credentials and enable multi-factor authentication (MFA) for all users.

**Operational Guidance:**
- Implement Just-In-Time (JIT) access for sensitive operations.
- Automate access reviews and alert on privilege escalations.
- Document access request and approval processes.

---

## 3. Namespace-Level Access Segmentation

**Overview:**
Namespaces in Kubernetes provide logical separation for workloads. Segmenting access at the namespace level helps enforce boundaries between teams, environments, or applications.

**Best Practices:**
- Create separate namespaces for different teams, environments (dev/test/prod), or applications.
- Use Kubernetes Roles and RoleBindings scoped to namespaces to restrict access.
- Limit cluster-wide permissions to only those who need them.
- Monitor namespace usage and access patterns.

**Operational Guidance:**
- Automate namespace creation and RBAC binding as part of onboarding workflows.
- Document namespace ownership and access policies.
- Use network policies to further isolate namespaces if required.
