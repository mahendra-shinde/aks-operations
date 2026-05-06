# Azure Container Registry (ACR) for AKS Operations

This module provides AKS Operations teams with practical guidance on managing container images using Azure Container Registry (ACR). It covers lifecycle management, tagging/versioning, retention, and security best practices to ensure reliable and secure image operations in production environments.

## 1. Image Lifecycle Management

**Overview:**
Image lifecycle management refers to the processes and policies for building, storing, updating, and retiring container images in ACR. Effective lifecycle management ensures that only trusted, up-to-date images are available for deployment, reducing risk and operational overhead.

**Key Practices:**
- Automate image builds using CI/CD pipelines (e.g., Azure DevOps, GitHub Actions).
- Push images to ACR after successful builds and tests.
- Remove deprecated or vulnerable images regularly.
- Use image locks or repository permissions to prevent accidental deletion of critical images.

**Operational Guidance:**
- Integrate image build and push steps into your deployment pipelines.
- Schedule regular reviews of ACR repositories to clean up unused images.
- Document image ownership and update responsibilities.

---

## 2. Tagging/Versioning Strategy

**Overview:**
Tagging and versioning images is essential for traceability, rollback, and promoting images through environments (dev, test, prod).

**Best Practices:**
- Use semantic versioning (e.g., `v1.2.3`) for application images.
- Avoid using the `latest` tag in production deployments; always reference a specific version.
- Include build metadata or commit hashes in tags for traceability (e.g., `v1.2.3-commitsha`).
- Establish a naming convention for tags (e.g., `<env>-<version>` or `<service>-<version>`).

**Operational Guidance:**
- Enforce tag policies in CI/CD pipelines.
- Document your team's tagging strategy and communicate it to all stakeholders.
- Use ACR Tasks or automation scripts to retag images as they move through environments.

---

## 3. Image Retention Policies

**Overview:**
Retention policies help control storage costs and reduce clutter by automatically deleting old or unused images.

**Best Practices:**
- Enable ACR retention policies to automatically remove untagged or stale images.
- Define retention rules based on age, tag, or usage frequency (e.g., keep last 10 versions, delete images older than 90 days).
- Regularly review storage usage and adjust policies as needed.

**Operational Guidance:**
- Use Azure Portal, CLI, or ARM templates to configure retention policies.
- Monitor ACR metrics for storage consumption and policy effectiveness.
- Communicate retention schedules to development teams to avoid accidental data loss.

---

## 4. Image Scanning Expectations (Security Posture)

**Overview:**
Image scanning is a critical security practice to detect vulnerabilities and misconfigurations in container images before deployment.

**Best Practices:**
- Integrate image scanning tools (e.g., Microsoft Defender for Cloud, Trivy, Aqua) into your CI/CD pipelines.
- Set policies to block deployment of images with critical or high vulnerabilities.
- Regularly review scan reports and remediate findings promptly.
- Enable continuous scanning for images stored in ACR.

**Operational Guidance:**
- Configure Microsoft Defender for Cloud to scan ACR images automatically.
- Document your vulnerability management process and escalation paths.
- Educate development teams on secure image creation and remediation workflows.

