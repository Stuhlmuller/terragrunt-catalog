variable "tags" {
  type    = map(string)
  default = {}
}

variable "labels" {
  type    = map(string)
  default = {}
}

variable "namespace" {
  type = string
}

variable "annotations" {
  type    = map(string)
  default = {}
}

variable "project" {
  type    = string
  default = "default"
}

variable "server" {
  type    = string
  default = "https://kubernetes.default.svc"
}

variable "repo_url" {
  type = string
}

variable "target_revision" {
  type    = string
  default = "HEAD"
}

variable "path" {
  type    = string
  default = null
}

variable "chart" {
  type    = string
  default = null
}

variable "helm_parameters" {
  type = list(object({
    name  = string,
    value = string
  }))
  default = []
}

variable "helm_values" {
  type    = string
  default = null
}

variable "automated_sync_policy" {
  type = object({
    prune       = optional(bool)
    self_heal   = optional(bool)
    allow_empty = optional(bool)
  })
  default = null
}
