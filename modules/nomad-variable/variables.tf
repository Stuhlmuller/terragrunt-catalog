variable "kms_key_id" {
  description = "AWS KMS key ID for OpenTofu state encryption"
  type        = string
}

variable "path" {
  description = "A unique path to create the variable at"
  type        = string
}

variable "namespace" {
  description = "The namespace to create the variable in"
  type        = string
  default     = "default"
}

variable "items" {
  description = "An arbitrary map of items to create in the variable"
  type        = map(string)
  sensitive   = true
}
