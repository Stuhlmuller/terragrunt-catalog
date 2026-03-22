# Terragrunt Catalog

A comprehensive Terragrunt configuration catalog for managing Nomad resources on AWS with OpenTofu state encryption.

## Overview

This repository contains reusable Terraform modules and Terragrunt units for deploying and managing HashiCorp Nomad resources with built-in state encryption using AWS KMS.

## Features

- **OpenTofu State Encryption**: All modules include AWS KMS encryption for state and plan files
- **Nomad Provider**: Latest Nomad provider (v2.5.2) with full resource support
- **AWS Integration**: Designed for AWS deployments with KMS integration
- **Security Best Practices**: Encrypted secrets, restricted capabilities, and proper IAM policies
- **Production Ready**: Includes namespace isolation, resource quotas, and monitoring

## Repository Structure

```
.
├── modules/                  # Reusable Terraform modules
│   ├── nomad-job/           # Nomad job management
│   ├── nomad-namespace/     # Nomad namespace management
│   └── nomad-variable/      # Nomad variable management
├── units/                    # Example Terragrunt configurations
│   ├── nomad-nginx-job/              # Simple web service deployment
│   ├── nomad-production-namespace/   # Production namespace setup
│   ├── nomad-app-secrets/           # Application configuration
│   └── nomad-batch-processor/       # Batch job example
└── terragrunt.hcl           # Root configuration

```

## Modules

### nomad-job

Manages Nomad job lifecycle with support for:
- HCL and JSON jobspec formats
- HCL2 variables and templating
- Configurable timeouts and policies
- State encryption with AWS KMS

[Module Documentation](modules/nomad-job/README.md)

### nomad-namespace

Creates and manages Nomad namespaces with:
- Resource quotas
- Task driver restrictions
- Network mode controls
- Custom metadata
- Node pool configuration (Enterprise)

[Module Documentation](modules/nomad-namespace/README.md)

### nomad-variable

Manages Nomad variables for configuration and secrets with:
- Namespace support
- Sensitive data handling
- KMS-encrypted state storage
- Integration with Nomad job templates

[Module Documentation](modules/nomad-variable/README.md)

## Units

### nomad-nginx-job

Example deployment of an Nginx web service with 3 replicas, health checks, and service discovery.

[Unit Documentation](units/nomad-nginx-job/README.md)

### nomad-production-namespace

Production namespace with security restrictions, compliance metadata, and allowed task drivers.

[Unit Documentation](units/nomad-production-namespace/README.md)

### nomad-app-secrets

Application configuration and secrets management using Nomad variables.

[Unit Documentation](units/nomad-app-secrets/README.md)

### nomad-batch-processor

Parameterized batch processing job for on-demand data processing tasks.

[Unit Documentation](units/nomad-batch-processor/README.md)

## Prerequisites

### Required Software

- [Terraform](https://www.terraform.io/downloads.html) >= 1.0 or [OpenTofu](https://opentofu.org/)
- [Terragrunt](https://terragrunt.gruntwork.io/) >= 0.45.0
- [Nomad](https://www.nomadproject.io/) cluster (client or server)
- AWS CLI configured with appropriate credentials

### AWS Resources

- **KMS Key**: Create a KMS key for state encryption
- **S3 Bucket**: For Terraform state storage
- **DynamoDB Table**: For state locking
- **IAM Permissions**: Access to KMS, S3, and DynamoDB

### Nomad Setup

- Nomad cluster deployed and accessible
- ACL tokens configured (recommended for production)
- Docker driver enabled on Nomad clients
- Consul for service discovery (optional)

## Quick Start

### 1. Configure Environment

```bash
# Set Nomad connection details
export NOMAD_ADDR="https://nomad.example.com:4646"
export NOMAD_TOKEN="your-nomad-acl-token" # checkov:skip=CKV_SECRET_6: Not a real secret
export ENVIRONMENT="production"

# Set AWS credentials
export AWS_REGION="us-east-1"
export AWS_PROFILE="default"
```

### 2. Update Root Configuration

Edit `terragrunt.hcl` and update:
- S3 bucket name
- DynamoDB table name
- KMS key ARN
- AWS region

### 3. Deploy a Namespace

```bash
cd units/nomad-production-namespace
terragrunt init
terragrunt plan
terragrunt apply
```

### 4. Configure Application Secrets

```bash
cd ../nomad-app-secrets
# Update terragrunt.hcl with your configuration
terragrunt init
terragrunt apply
```

### 5. Deploy a Job

```bash
cd ../nomad-nginx-job
terragrunt init
terragrunt plan
terragrunt apply

# Verify deployment
nomad job status nginx-web
```

## OpenTofu Encryption

All modules include OpenTofu encryption configuration using AWS KMS:

```hcl
terraform {
  encryption {
    key_provider "aws_kms" "main" {
      kms_key_id = var.kms_key_id
      key_spec   = "AES_256"
    }

    method "aes_gcm" "main" {
      keys = key_provider.aws_kms.main
    }

    state {
      method   = method.aes_gcm.main
      enforced = true
    }

    plan {
      method   = method.aes_gcm.main
      enforced = true
    }
  }
}
```

### Benefits

- **State Protection**: Terraform state files are encrypted at rest
- **Plan Security**: Plan files containing sensitive data are encrypted
- **Compliance**: Meets security requirements for sensitive infrastructure
- **Key Management**: Centralized key management through AWS KMS
- **Audit Trail**: KMS provides audit logging for key usage

## Security Considerations

### State File Security

- State files contain sensitive information and are encrypted with KMS
- Store state files in S3 with encryption and versioning enabled
- Use IAM policies to restrict access to state buckets
- Enable S3 bucket logging for audit trails

### Nomad Variables

- Use Nomad variables for configuration, not highly sensitive secrets
- For passwords and API keys, consider AWS Secrets Manager or Vault
- Restrict access using Nomad ACL policies
- Rotate credentials regularly

### IAM Permissions

Required IAM permissions for KMS:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "kms:Encrypt",
        "kms:Decrypt",
        "kms:DescribeKey",
        "kms:GenerateDataKey"
      ],
      "Resource": "arn:aws:kms:REGION:ACCOUNT:key/KEY-ID"
    }
  ]
}
```

### Network Security

- Use TLS for Nomad connections
- Enable ACLs on Nomad clusters
- Use security groups to restrict access
- Consider using mTLS for Nomad communication

## Common Workflows

### Creating a New Application

1. Create namespace (if not exists)
2. Configure variables for the application
3. Deploy the Nomad job
4. Verify service registration
5. Set up monitoring and alerting

### Updating a Job

```bash
cd units/your-job
# Edit terragrunt.hcl with changes
terragrunt plan
terragrunt apply

# Monitor the update
nomad job status your-job
```

### Managing Secrets

```bash
cd units/nomad-app-secrets
# Update items in terragrunt.hcl
terragrunt apply

# Jobs using these variables will need to be restarted
nomad job restart -namespace=production your-job
```

## Troubleshooting

### KMS Access Denied

```bash
# Verify KMS permissions
aws kms describe-key --key-id your-key-id

# Check IAM role/user has correct permissions
aws iam get-role-policy --role-name your-role --policy-name your-policy
```

### Nomad Connection Issues

```bash
# Verify Nomad is accessible
nomad status

# Check ACL token
nomad acl token self

# Test connection
curl -H "X-Nomad-Token: $NOMAD_TOKEN" $NOMAD_ADDR/v1/status/leader
```

### State Locking Errors

```bash
# Force unlock if needed (use with caution)
terragrunt force-unlock LOCK_ID
```

## Contributing

When adding new modules or units:

1. Include OpenTofu encryption configuration
2. Document all variables and outputs
3. Provide a comprehensive README
4. Include security considerations
5. Add example usage

## Resources

- [Nomad Documentation](https://www.nomadproject.io/docs)
- [Terraform Nomad Provider](https://registry.terraform.io/providers/hashicorp/nomad/latest/docs)
- [OpenTofu Encryption](https://opentofu.org/docs/language/state/encryption/)
- [AWS KMS Documentation](https://docs.aws.amazon.com/kms/)
- [Terragrunt Documentation](https://terragrunt.gruntwork.io/docs/)

## License

See LICENSE file for details.
