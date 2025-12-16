variable "name" {
  type        = string
  description = "The name of the certificate"
}

variable "namespace" {
  type        = string
  description = "The namespace of the certificate"
}

variable "dns_names" {
  type        = list(string)
  description = "The DNS names of the certificate"
}

variable "tags" {
  type        = map(string)
  description = "The tags of the certificate"
  default     = {}
}
