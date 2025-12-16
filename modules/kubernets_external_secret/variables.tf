variable "secrets" {
  type        = list(string)
  description = "The secrets to create"
}

variable "namespace" {
  type        = string
  description = "The namespace to create the secrets in"
}

variable "secret_name" {
  type        = string
  description = "The name of the secret"
}

variable "refresh_policy" {
  type        = string
  description = "The refresh policy for the secret"
  default     = "OnChange"
}

variable "description" {
  type        = string
  description = "The description of the secret"
  default     = "Kubernetes External Secret"
}
