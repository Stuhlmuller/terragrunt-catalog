output "id" {
  description = "The ID of the variable"
  value       = nomad_variable.this.id
}

output "path" {
  description = "The path of the variable"
  value       = nomad_variable.this.path
}

output "namespace" {
  description = "The namespace of the variable"
  value       = nomad_variable.this.namespace
}

output "items" {
  description = "The items stored in the variable"
  value       = nomad_variable.this.items
  sensitive   = true
}
