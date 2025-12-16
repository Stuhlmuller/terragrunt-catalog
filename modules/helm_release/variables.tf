variable "namespace" {
  type        = string
  description = "The name of the namespace to install the helm chart in"
}

variable "name" {
  type        = string
  description = "The name of the helm release"
}

variable "repository" {
  type        = string
  description = "The repository of the helm chart"
}

variable "chart" {
  type        = string
  description = "The chart of the helm chart"
}

variable "tags" {
  type        = map(string)
  description = "The tags to add to the helm release"
  default     = {}
}
