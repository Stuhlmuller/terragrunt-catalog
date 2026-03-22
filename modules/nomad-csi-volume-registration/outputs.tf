output "id" {
  description = "The ID of the volume registration"
  value       = nomad_csi_volume_registration.this.id
}

output "volume_id" {
  description = "The unique ID of the volume"
  value       = nomad_csi_volume_registration.this.volume_id
}

output "name" {
  description = "The display name of the volume"
  value       = nomad_csi_volume_registration.this.name
}

output "namespace" {
  description = "The namespace of the volume"
  value       = nomad_csi_volume_registration.this.namespace
}

output "external_id" {
  description = "The external ID of the physical volume"
  value       = nomad_csi_volume_registration.this.external_id
}

output "plugin_id" {
  description = "The ID of the CSI plugin"
  value       = nomad_csi_volume_registration.this.plugin_id
}

output "plugin_provider" {
  description = "The provider of the CSI plugin"
  value       = nomad_csi_volume_registration.this.plugin_provider
}

output "plugin_provider_version" {
  description = "The version of the CSI plugin provider"
  value       = nomad_csi_volume_registration.this.plugin_provider_version
}

output "controller_required" {
  description = "Whether a controller is required for this volume"
  value       = nomad_csi_volume_registration.this.controller_required
}

output "controllers_expected" {
  description = "The expected number of controllers"
  value       = nomad_csi_volume_registration.this.controllers_expected
}

output "controllers_healthy" {
  description = "The number of healthy controllers"
  value       = nomad_csi_volume_registration.this.controllers_healthy
}

output "nodes_expected" {
  description = "The expected number of nodes"
  value       = nomad_csi_volume_registration.this.nodes_expected
}

output "nodes_healthy" {
  description = "The number of healthy nodes"
  value       = nomad_csi_volume_registration.this.nodes_healthy
}

output "schedulable" {
  description = "Whether the volume is schedulable"
  value       = nomad_csi_volume_registration.this.schedulable
}

output "topologies" {
  description = "The list of topologies for the volume"
  value       = nomad_csi_volume_registration.this.topologies
}

output "access_mode" {
  description = "The access mode of the volume"
  value       = nomad_csi_volume_registration.this.access_mode
}

output "attachment_mode" {
  description = "The attachment mode of the volume"
  value       = nomad_csi_volume_registration.this.attachment_mode
}
