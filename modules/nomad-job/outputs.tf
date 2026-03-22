output "id" {
  description = "The ID of the job"
  value       = nomad_job.this.id
}

output "name" {
  description = "The name of the job"
  value       = nomad_job.this.name
}

output "namespace" {
  description = "The namespace of the job"
  value       = nomad_job.this.namespace
}

output "type" {
  description = "The type of the job"
  value       = nomad_job.this.type
}

output "region" {
  description = "The region of the job"
  value       = nomad_job.this.region
}

output "datacenters" {
  description = "The datacenters where the job is deployed"
  value       = nomad_job.this.datacenters
}

output "task_groups" {
  description = "The task groups in the job"
  value       = nomad_job.this.task_groups
}

output "allocation_ids" {
  description = "The allocation IDs for the job"
  value       = nomad_job.this.allocation_ids
}

output "status" {
  description = "The status of the job"
  value       = nomad_job.this.status
}
