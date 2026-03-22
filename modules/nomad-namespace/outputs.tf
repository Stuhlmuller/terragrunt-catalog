output "id" {
  description = "The ID of the namespace"
  value       = nomad_namespace.this.id
}

output "name" {
  description = "The name of the namespace"
  value       = nomad_namespace.this.name
}

output "description" {
  description = "The description of the namespace"
  value       = nomad_namespace.this.description
}

output "quota" {
  description = "The quota attached to the namespace"
  value       = nomad_namespace.this.quota
}

output "meta" {
  description = "The metadata associated with the namespace"
  value       = nomad_namespace.this.meta
}
