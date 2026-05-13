# Secrets & ConfigMaps – Enterprise Security

## Kubernetes Secrets vs Azure Key Vault Decision Model
Kubernetes Secrets and Azure Key Vault serve different purposes and have distinct advantages. Understanding when to use each is critical for maintaining enterprise security.

### Kubernetes Secrets
- **Use Case**: Best for storing sensitive data like passwords, tokens, and keys within the Kubernetes cluster.
- **Advantages**:
  - Integrated with Kubernetes RBAC for access control.
  - Lightweight and easy to use for cluster-local applications.
- **Limitations**:
  - Secrets are base64-encoded, not encrypted by default.
  - Requires additional configuration for encryption at rest.

### Azure Key Vault
- **Use Case**: Ideal for managing secrets, certificates, and keys at scale across multiple environments.
- **Advantages**:
  - Provides hardware security module (HSM) backed key management.
  - Supports secret versioning and access policies.
  - Integrated with Azure Active Directory for fine-grained access control.
- **Limitations**:
  - Requires external connectivity from the Kubernetes cluster.
  - Slightly more complex to configure compared to Kubernetes Secrets.

### Decision Model
- Use Kubernetes Secrets for cluster-local, lightweight applications.
- Use Azure Key Vault for enterprise-grade security, especially when managing secrets across multiple environments.

## Secret Rotation Strategies
Secret rotation is essential to minimize the risk of credential exposure. Here are some strategies:

1. **Automated Rotation**:
   - Use tools like Azure Key Vault or external secret operators to automate secret rotation.
   - Ensure applications can dynamically reload secrets without downtime.

2. **Manual Rotation**:
   - Rotate secrets periodically based on organizational policies.
   - Update Kubernetes Secrets or Key Vault entries and restart dependent applications.

3. **Versioning**:
   - Maintain multiple versions of secrets during rotation to ensure a smooth transition.
   - Gradually phase out old versions after verifying application updates.

4. **Monitoring and Alerts**:
   - Set up alerts for unauthorized access attempts.
   - Monitor secret usage to detect anomalies.

## Access Control Boundaries
Defining clear access control boundaries is critical for securing secrets and configurations.

1. **Role-Based Access Control (RBAC)**:
   - Use Kubernetes RBAC to restrict access to Secrets and ConfigMaps.
   - Assign roles based on the principle of least privilege.

2. **Namespace Isolation**:
   - Use namespaces to isolate resources and limit access to Secrets and ConfigMaps.
   - Apply network policies to restrict inter-namespace communication.

3. **Azure Key Vault Access Policies**:
   - Define granular access policies for users and applications.
   - Use Azure Managed Identities to simplify authentication.

4. **Audit and Compliance**:
   - Regularly audit access logs to ensure compliance with security policies.
   - Use tools like Azure Policy to enforce access control standards.

## Config Drift Risks in Regulated Environments
Configuration drift occurs when the actual state of a system diverges from the desired state. This can lead to security vulnerabilities, especially in regulated environments.

### Risks
- **Non-Compliance**: Drift can result in non-compliance with regulatory standards.
- **Security Vulnerabilities**: Misconfigured secrets or access controls can expose sensitive data.
- **Operational Disruptions**: Drift can cause application failures or unexpected behavior.

### Mitigation Strategies
1. **Infrastructure as Code (IaC)**:
   - Use tools like Terraform or Azure Resource Manager templates to define and enforce desired configurations.
   - Store configurations in version-controlled repositories.

2. **Continuous Monitoring**:
   - Use tools like Azure Policy or Kubernetes Admission Controllers to detect and prevent drift.
   - Set up alerts for configuration changes.

3. **Regular Audits**:
   - Conduct periodic audits to identify and remediate drift.
   - Compare the current state with the desired state defined in IaC templates.

4. **Automated Remediation**:
   - Implement automated workflows to revert unauthorized changes.
   - Use tools like Flux or ArgoCD for GitOps-based configuration management.
