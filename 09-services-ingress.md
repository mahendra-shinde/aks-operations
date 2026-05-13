# Ingress – Enterprise Patterns

## Services in Kubernetes
Kubernetes services provide a stable endpoint for accessing a group of pods. Understanding the different types of services is essential for managing application traffic.

### Types of Services
1. **ClusterIP**:
   - Default service type.
   - Exposes the service on an internal IP within the cluster.
   - Used for internal communication between services.

2. **NodePort**:
   - Exposes the service on a static port on each node.
   - Allows external access to the service using `<NodeIP>:<NodePort>`.

3. **LoadBalancer**:
   - Provisions an external load balancer to expose the service.
   - Commonly used in cloud environments like Azure.

4. **ExternalName**:
   - Maps the service to an external DNS name.
   - Useful for integrating external services.

## Private Ingress Patterns
Private ingress patterns are used to restrict access to services within a private network, ensuring secure communication.

### Key Patterns
1. **Internal Load Balancer**:
   - Use an internal load balancer to expose services only within the virtual network.
   - Configure the `service.beta.kubernetes.io/azure-load-balancer-internal` annotation for Azure.

2. **Private Link**:
   - Use Azure Private Link to securely access services over a private endpoint.
   - Eliminates the need for public IP addresses.

3. **Network Policies**:
   - Define network policies to restrict traffic to specific pods or namespaces.
   - Use tools like Calico or Azure CNI for advanced network policy management.

## TLS & Certificate Management
TLS ensures secure communication between clients and services. Proper certificate management is critical for maintaining security.

### TLS Configuration
1. **Ingress Controller**:
   - Use an ingress controller like NGINX or Azure Application Gateway to terminate TLS.
   - Configure TLS certificates in the ingress resource.

2. **Certificate Issuers**:
   - Use tools like Cert-Manager to automate certificate issuance and renewal.
   - Integrate with ACME providers like Let’s Encrypt or Azure Key Vault.

3. **Certificate Rotation**:
   - Regularly rotate certificates to minimize the risk of compromise.
   - Automate rotation using Cert-Manager or Azure Key Vault.

## Internal vs External Exposure
Determining whether to expose services internally or externally depends on the application’s requirements and security considerations.

### Internal Exposure
- **Use Cases**:
  - Backend services that do not require direct access from the internet.
  - Services communicating within the same virtual network.
- **Best Practices**:
  - Use internal load balancers.
  - Apply network policies to restrict access.

### External Exposure
- **Use Cases**:
  - Frontend services that need to be accessible from the internet.
  - APIs consumed by external clients.
- **Best Practices**:
  - Use external load balancers or ingress controllers.
  - Secure endpoints with TLS.
  - Implement Web Application Firewalls (WAF) for additional protection.

