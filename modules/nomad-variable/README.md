# Nomad Variable Module

This module manages Nomad variable resources with OpenTofu state encryption using AWS KMS.

## Features

- Nomad variable lifecycle management
- Namespace support
- Sensitive data handling
- OpenTofu state and plan encryption with AWS KMS

## Security Warning

This resource stores sensitive values in Terraform's state file. The OpenTofu encryption with AWS KMS provides additional protection for the state file, but you should still follow security best practices:

- Use encryption at rest for state storage
- Limit access to state files
- Use proper IAM policies for KMS key access
- Consider using dynamic secrets when possible

## Usage

### Basic Variable

```hcl
module "nomad_variable" {
  source = "./modules/nomad-variable"

  kms_key_id = "arn:aws:kms:us-east-1:123456789012:key/example"
  path       = "app/config/database"

  items = {
    db_host     = "postgres.example.com"
    db_port     = "5432"
    db_name     = "myapp"
    db_username = "app_user"
  }
}
```

### Variable in Custom Namespace

```hcl
module "nomad_namespace" {
  source = "./modules/nomad-namespace"

  kms_key_id  = "arn:aws:kms:us-east-1:123456789012:key/example"
  name        = "production"
  description = "Production namespace"
}

module "nomad_variable_prod" {
  source = "./modules/nomad-variable"

  kms_key_id = "arn:aws:kms:us-east-1:123456789012:key/example"
  path       = "app/config/secrets"
  namespace  = module.nomad_namespace.name

  items = {
    api_key       = var.api_key
    secret_token  = var.secret_token
    webhook_url   = "https://api.example.com/webhooks"
  }
}
```

### Application Configuration

```hcl
module "app_config" {
  source = "./modules/nomad-variable"

  kms_key_id = "arn:aws:kms:us-east-1:123456789012:key/example"
  path       = "myapp/config"

  items = {
    log_level        = "info"
    max_connections  = "100"
    timeout_seconds  = "30"
    feature_flag_x   = "enabled"
  }
}
```

### Using Variables in Nomad Jobs

Reference variables in your Nomad job templates:

```hcl
template {
  data = <<EOT
{{ with nomadVar "app/config/database" }}
DB_HOST={{ .db_host }}
DB_PORT={{ .db_port }}
DB_NAME={{ .db_name }}
DB_USERNAME={{ .db_username }}
{{ end }}
EOT
  destination = "secrets/db.env"
  env         = true
}
```

## OpenTofu Encryption

This module includes state and plan encryption using AWS KMS. The encryption configuration:

- Uses AES-256-GCM encryption method
- Requires a valid AWS KMS key ID
- Encrypts both state and plan files
- Enforces encryption for all operations
- Provides additional protection for sensitive variable data

## Requirements

- Terraform/OpenTofu >= 1.0
- Nomad Provider ~> 2.5.2
- AWS credentials with KMS access
