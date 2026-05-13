# Storage & Persistence – Operations Depth

## Persistent Volume (PV) Lifecycle
Persistent Volumes (PVs) are a key component of Kubernetes storage, providing a way to manage storage independently of the lifecycle of pods. Understanding the PV lifecycle is essential for ensuring reliable storage operations.

### PV Lifecycle Stages
1. **Provisioning**:
   - PVs can be provisioned statically or dynamically.
   - Static provisioning involves pre-creating PVs by administrators.
   - Dynamic provisioning uses storage classes to create PVs on demand.

2. **Binding**:
   - A PV is bound to a Persistent Volume Claim (PVC) when the PVC's requirements match the PV's specifications.
   - Binding is a one-to-one relationship.

3. **Using**:
   - Once bound, the PV is mounted to a pod and used for storage.
   - Applications can read/write data to the PV as defined by the access mode (e.g., ReadWriteOnce, ReadOnlyMany).

4. **Reclaiming**:
   - When a PVC is deleted, the PV enters the reclaim phase.
   - Reclaim policies determine the fate of the PV:
     - **Retain**: The PV remains with its data intact.
     - **Recycle**: The PV is scrubbed and made available for reuse.
     - **Delete**: The PV and its associated storage are deleted.

## Persistent Volume Claim (PVC) States
PVCs represent a request for storage by a user. Understanding PVC states helps diagnose and resolve storage issues.

### PVC States
1. **Pending**:
   - The PVC is waiting for a suitable PV to be bound.
   - Common causes:
     - No matching PVs available.
     - Storage class misconfiguration.

2. **Bound**:
   - The PVC is successfully bound to a PV.
   - The storage is ready for use by a pod.

3. **Lost**:
   - The PV bound to the PVC is no longer available.
   - This can occur due to storage backend issues or manual deletion of the PV.

## Failure Scenarios
Failures in storage and persistence can disrupt application availability. Here are common failure scenarios and their resolutions:

### PVC Stuck in Pending
- **Symptoms**:
  - PVC remains in the Pending state indefinitely.
- **Causes**:
  - No available PVs match the PVC's requirements.
  - Misconfigured storage class.
- **Resolutions**:
  - Verify the PVC's resource requests (e.g., storage size, access modes).
  - Check if a matching PV exists or if dynamic provisioning is enabled.
  - Ensure the correct storage class is specified in the PVC.

### Storage Class Mismatch
- **Symptoms**:
  - PVC fails to bind to a PV.
- **Causes**:
  - The PVC references a storage class that does not exist or is misconfigured.
- **Resolutions**:
  - Verify the storage class name in the PVC.
  - Check the storage class configuration using `kubectl get sc`.
  - Ensure the storage class supports the required parameters (e.g., volume binding mode).

### Node Disk Pressure Impact
- **Symptoms**:
  - Pods using PVCs are evicted or fail to start.
- **Causes**:
  - Node disk pressure due to insufficient disk space.
- **Resolutions**:
  - Monitor node disk usage using `kubectl describe node`.
  - Increase node disk capacity or clean up unused resources.
  - Use taints and tolerations to manage pod scheduling during disk pressure.
