# Nomad Batch Processor Job Unit

This unit deploys a parameterized batch processing job in Nomad for on-demand data processing.

## Description

Creates a parameterized batch job with:
- On-demand execution model
- Required payload and metadata
- Integration with Nomad variables for configuration
- Automatic retry logic
- Resource limits

## Features

- **Parameterized**: Can be dispatched with different parameters
- **Batch Type**: Runs to completion then exits
- **Config Integration**: Uses Nomad variables from `nomad-app-secrets`
- **Resource Management**: CPU and memory limits defined
- **Log Management**: Configurable log rotation

## Prerequisites

- Production namespace deployed (`nomad-production-namespace` unit)
- Application secrets configured (`nomad-app-secrets` unit)
- Docker image `my-company/batch-processor:latest` available
- AWS KMS key for state encryption

## Usage

### Deploy the Job

```bash
# Initialize and apply
terragrunt init
terragrunt plan
terragrunt apply
```

### Dispatch the Parameterized Job

```bash
# Dispatch with metadata
nomad job dispatch \
  -namespace=production \
  -meta job_id=process-001 \
  -meta input_file=s3://bucket/data/input.csv \
  batch-processor

# Dispatch with payload
echo '{"data": "value"}' | nomad job dispatch \
  -namespace=production \
  -meta job_id=process-002 \
  -meta input_file=s3://bucket/data/input2.csv \
  batch-processor -

# Monitor the dispatched job
nomad job status -namespace=production <dispatched-job-id>

# View logs
nomad alloc logs -namespace=production <alloc-id>
```

## Configuration

### Customizing the Job

Edit `terragrunt.hcl` to modify:
- Docker image name and version
- Resource allocations (CPU/memory)
- Restart policy
- Required metadata fields
- Log rotation settings

### Example: Change Resources

```hcl
resources {
  cpu    = 2000  # Increase to 2 CPU cores
  memory = 4096  # Increase to 4GB RAM
}
```

## Integration with Variables

This job automatically loads configuration from the `nomad-app-secrets` unit:
- Database connection settings
- API configuration
- Application settings

The template block injects these as environment variables into the container.

## Monitoring

```bash
# List all dispatched instances
nomad job status -namespace=production batch-processor

# Check specific dispatch
nomad alloc status <alloc-id>

# View real-time logs
nomad alloc logs -f <alloc-id>

# Check job history
nomad job history -namespace=production batch-processor
```

## Common Use Cases

1. **Data Processing**: Process files uploaded to S3
2. **Report Generation**: Generate reports on demand
3. **ETL Jobs**: Extract, transform, and load data
4. **Cleanup Tasks**: Periodic or on-demand cleanup operations
5. **Batch Analytics**: Run analytics on datasets

## Security Considerations

- Job runs in the `production` namespace with defined capabilities
- Secrets loaded from encrypted Nomad variables
- State file encrypted with AWS KMS
- Container runs with defined resource limits
- Logs are automatically rotated and limited
