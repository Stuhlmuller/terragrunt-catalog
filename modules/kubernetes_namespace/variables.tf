variable "name" {
  type        = string
  description = "The name of the namespace"
}

variable "labels" {
  type        = map(string)
  description = "The labels of the namespace"
  default     = {}
}

variable "annotations" {
  type        = map(string)
  description = "The annotations of the namespace"
  default     = {}
}

variable "generate_name" {
  type        = string
  description = "The generate name of the namespace"
  default     = null

  validation {
    condition     = var.name == null
    error_message = "Either name or generate_name must be provided, but not both."
  }
}

variable "tags" {
  type        = map(string)
  description = "The tags of the namespace"
  default     = {}
}
