# Nomad Job Module

This module manages Nomad job resources with OpenTofu state encryption using AWS KMS.

## Features

- Nomad job lifecycle management
- Support for HCL and JSON jobspec formats
- HCL2 variable support
- OpenTofu state and plan encryption with AWS KMS
- Configurable timeouts and policies

## Usage

```hcl
module "nomad_job" {
  source = "./modules/nomad-job"

  kms_key_id       = "arn:aws:kms:us-east-1:123456789012:key/example"
  jobspec_file     = "${path.module}/my-job.nomad"
  detach           = false

  timeouts = {
    create = "10m"
    update = "10m"
  }
}
```

### With HCL2 Variables

```hcl
module "nomad_job_hcl2" {
  source = "./modules/nomad-job"

  kms_key_id    = "arn:aws:kms:us-east-1:123456789012:key/example"
  jobspec_file  = "${path.module}/parameterized-job.nomad"
  hcl2_enabled  = true

  hcl2_vars = {
    datacenters       = "[\"dc1\", \"dc2\"]"
    restart_attempts  = "5"
    memory_mb         = "512"
  }
}
```

### Inline Jobspec

```hcl
module "nomad_job_inline" {
  source = "./modules/nomad-job"

  kms_key_id = "arn:aws:kms:us-east-1:123456789012:key/example"

  jobspec_content = <<EOT
job "example" {
  datacenters = ["dc1"]
  type        = "service"

  group "app" {
    task "server" {
      driver = "docker"

      config {
        image = "nginx:latest"
        ports = ["http"]
      }

      resources {
        cpu    = 500
        memory = 256
      }
    }
  }
}
EOT
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
