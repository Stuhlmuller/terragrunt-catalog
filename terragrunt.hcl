# Root Terragrunt Configuration
# This file is included by all child units using find_in_parent_folders()

locals {
  # AWS configuration
  aws_region = "us-east-1"

  # Nomad configuration
  nomad_address = get_env("NOMAD_ADDR", "http://localhost:4646")
  nomad_token   = get_env("NOMAD_TOKEN", "")

  # Environment configuration
  environment = get_env("ENVIRONMENT", "dev")
}

# Configure Terragrunt to use S3 backend with encryption
remote_state {
  backend = "s3"

  config = {
    bucket         = "my-terraform-state-${local.environment}"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = local.aws_region
    encrypt        = true
    dynamodb_table = "terraform-state-lock-${local.environment}"

    # S3 bucket encryption
    kms_key_id = "arn:aws:kms:${local.aws_region}:123456789012:key/12345678-1234-1234-1234-123456789012"
  }

  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

# Generate provider configuration
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "nomad" {
  address = "${local.nomad_address}"
  token   = "${local.nomad_token}"
  region  = "global"
}

provider "aws" {
  region = "${local.aws_region}"

  default_tags {
    tags = {
      ManagedBy   = "Terragrunt"
      Environment = "${local.environment}"
      Repository  = "terragrunt-catalog"
    }
  }
}
EOF
}

# Retry configuration for transient errors
retryable_errors = [
  "(?s).*failed to dial.*",
  "(?s).*connection refused.*",
  "(?s).*timeout.*",
  "(?s).*TLS handshake timeout.*",
]

retry_max_attempts       = 3
retry_sleep_interval_sec = 5

# Input variables that can be used by all child configurations
inputs = {
  aws_region    = local.aws_region
  environment   = local.environment
  nomad_address = local.nomad_address
}
