# Nomad CSI Volume Registration Module

This module registers an existing CSI volume with Nomad. Use this when you have an existing storage volume (like a NAS) that you want to make available to your Nomad workloads.

## Use Case

Perfect for:
- Connecting existing NAS storage to Nomad
- Registering pre-provisioned storage volumes
- Integrating external storage systems with Nomad

## Prerequisites

1. A Nomad CSI plugin must be deployed and running in your cluster
2. The external volume must already exist on your storage backend
3. You need the external ID of the volume from your storage provider

## Common CSI Plugins for NAS

- **NFS**: Use the `nfs-csi` plugin for NFS shares
- **SMB/CIFS**: Use the `smb-csi` plugin for Windows shares
- **iSCSI**: Use the `democratic-csi` or similar for iSCSI

## Example Usage

### NFS Volume Registration

```hcl
module "nas_volume" {
  source = "./modules/nomad-csi-volume-registration"

  kms_key_id  = "arn:aws:kms:us-east-1:123456789012:key/..."
  volume_id   = "nas-home-media"
  name        = "NAS Home Media"
  plugin_id   = "nfs-csi"
  external_id = "nas.example.com:/mnt/media"

  capabilities = [
    {
      access_mode     = "multi-node-multi-writer"
      attachment_mode = "file-system"
    }
  ]

  mount_options = {
    fs_type = "nfs"
    mount_flags = [
      "vers=4.1",
      "noatime"
    ]
  }
}
```

### SMB/CIFS Share Registration

```hcl
module "smb_volume" {
  source = "./modules/nomad-csi-volume-registration"

  kms_key_id  = "arn:aws:kms:us-east-1:123456789012:key/..."
  volume_id   = "smb-documents"
  name        = "SMB Documents Share"
  plugin_id   = "smb-csi"
  external_id = "//nas.example.com/documents"

  capabilities = [
    {
      access_mode     = "multi-node-reader-only"
      attachment_mode = "file-system"
    }
  ]

  secrets = {
    username = "nasuser"
    password = "secure-password"  # checkov:skip=CKV_SECRET_6: placeholder secret
  }
}
```

## Access Modes

Choose the appropriate access mode for your use case:

- `single-node-reader-only`: One node, read-only
- `single-node-writer`: One node, read-write
- `multi-node-reader-only`: Multiple nodes, read-only
- `multi-node-single-writer`: Multiple nodes, one writer
- `multi-node-multi-writer`: Multiple nodes, all can write (NFS, etc.)

## Attachment Modes

- `file-system`: For file-based storage (NFS, SMB, etc.)
- `block-device`: For block storage (iSCSI, etc.)

## Important Notes

- The volume must already exist on your storage backend
- Set `deregister_on_destroy = false` if you want to keep the volume registration when destroying Terraform resources
- Use `secrets` variable for authentication credentials (stored encrypted in state)
- The `external_id` format depends on your CSI plugin and storage type
