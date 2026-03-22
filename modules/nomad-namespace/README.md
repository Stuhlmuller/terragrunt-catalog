# Nomad Namespace Module

This module manages Nomad namespace resources with OpenTofu state encryption using AWS KMS.

## Features

- Nomad namespace lifecycle management
- Resource quota support
- Custom metadata support
- Task driver and network mode capabilities
- Node pool configuration (Enterprise)
- OpenTofu state and plan encryption with AWS KMS

## Usage

### Basic Namespace

```hcl
module "nomad_namespace" {
  source = "./modules/nomad-namespace"

  kms_key_id  = "arn:aws:kms:us-east-1:123456789012:key/example"
  name        = "production"
  description = "Production environment namespace"

  meta = {
    team        = "platform"
    environment = "prod"
    owner       = "devops@example.com"
  }
}
```

### Namespace with Capabilities

```hcl
module "nomad_namespace_restricted" {
  source = "./modules/nomad-namespace"

  kms_key_id  = "arn:aws:kms:us-east-1:123456789012:key/example"
  name        = "restricted"
  description = "Restricted namespace with limited capabilities"

  capabilities = {
    enabled_task_drivers  = ["docker", "exec"]
    disabled_task_drivers = ["raw_exec"]
    enabled_network_modes = ["bridge", "host"]
  }
}
```

### Namespace with Quota

```hcl
resource "nomad_quota_specification" "dev" {
  name        = "dev-quota"
  description = "Development team quota"

  limits {
    region = "global"
    region_limit {
      cpu       = 2000
      memory_mb = 4096
    }
  }
}

module "nomad_namespace_dev" {
  source = "./modules/nomad-namespace"

  kms_key_id  = "arn:aws:kms:us-east-1:123456789012:key/example"
  name        = "development"
  description = "Development environment"
  quota       = nomad_quota_specification.dev.name
}
```

### Enterprise: Node Pool Configuration

```hcl
module "nomad_namespace_enterprise" {
  source = "./modules/nomad-namespace"

  kms_key_id  = "arn:aws:kms:us-east-1:123456789012:key/example"
  name        = "enterprise"
  description = "Enterprise namespace with node pool config"

  node_pool_config = {
    default = "prod-pool"
    allowed = ["prod-pool", "backup-pool"]
    denied  = ["dev-pool"]
  }
}
```

## OpenTofu Encryption

This module includes state and plan encryption using AWS KMS. The encryption configuration:

- Uses AES-256-GCM encryption method
- Requires a valid AWS KMS key ID
- Encrypts both state and plan files
- Enforces encryption for all operations

## Requirements

- Terraform/OpenTofu >= 1.0
- Nomad Provider ~> 2.5.2
- AWS credentials with KMS access
