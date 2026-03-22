# Nomad CSI Volume Module

This module creates and registers a new CSI volume in Nomad. Use this when you want Nomad to provision a new volume on your storage backend.

## Use Case

Perfect for:
- Creating new persistent volumes for applications
- Provisioning storage dynamically through Nomad
- Creating volumes from snapshots or clones

## Prerequisites

1. A Nomad CSI plugin must be deployed and running in your cluster
2. The CSI plugin must support volume creation (controller mode)
3. Your storage backend must support dynamic provisioning

## Example Usage

### Create a New Volume

```hcl
module "app_volume" {
  source = "./modules/nomad-csi-volume"

  kms_key_id   = "arn:aws:kms:us-east-1:123456789012:key/..."
  volume_id    = "mysql-data"
  name         = "MySQL Data Volume"
  plugin_id    = "aws-ebs0"
  capacity_min = "10GiB"
  capacity_max = "50GiB"

  capabilities = [
    {
      access_mode     = "single-node-writer"
      attachment_mode = "file-system"
    }
  ]

  mount_options = {
    fs_type = "ext4"
  }

  prevent_destroy = true
}
```

### Create Volume from Snapshot

```hcl
module "restored_volume" {
  source = "./modules/nomad-csi-volume"

  kms_key_id  = "arn:aws:kms:us-east-1:123456789012:key/..."
  volume_id   = "restored-data"
  name        = "Restored Data Volume"
  plugin_id   = "aws-ebs0"
  snapshot_id = "snap-0123456789abcdef"

  capabilities = [
    {
      access_mode     = "single-node-writer"
      attachment_mode = "file-system"
    }
  ]
}
```

### Clone Existing Volume

```hcl
module "cloned_volume" {
  source = "./modules/nomad-csi-volume"

  kms_key_id = "arn:aws:kms:us-east-1:123456789012:key/..."
  volume_id  = "cloned-volume"
  name       = "Cloned Volume"
  plugin_id  = "aws-ebs0"
  clone_id   = "vol-0123456789abcdef"

  capabilities = [
    {
      access_mode     = "single-node-writer"
      attachment_mode = "file-system"
    }
  ]
}
```

### Volume with Topology Constraints

```hcl
module "zone_constrained_volume" {
  source = "./modules/nomad-csi-volume"

  kms_key_id   = "arn:aws:kms:us-east-1:123456789012:key/..."
  volume_id    = "zone-volume"
  name         = "Zone-Constrained Volume"
  plugin_id    = "aws-ebs0"
  capacity_min = "10GiB"

  capabilities = [
    {
      access_mode     = "single-node-writer"
      attachment_mode = "file-system"
    }
  ]

  topology_request = {
    required = {
      topologies = [
        {
          segments = {
            zone = "us-east-1a"
          }
        }
      ]
    }
  }
}
```

## Access Modes

- `single-node-reader-only`: One node, read-only
- `single-node-writer`: One node, read-write
- `multi-node-reader-only`: Multiple nodes, read-only
- `multi-node-single-writer`: Multiple nodes, one writer
- `multi-node-multi-writer`: Multiple nodes, all can write

## Attachment Modes

- `file-system`: For file-based storage
- `block-device`: For raw block storage

## Important Notes

- By default, `prevent_destroy = true` to avoid accidental data loss
- You cannot specify both `snapshot_id` and `clone_id`
- Destroying this resource will delete the volume and all its data
- Use the `prevent_destroy` lifecycle rule in production
- Capacity constraints may not be supported by all storage providers
