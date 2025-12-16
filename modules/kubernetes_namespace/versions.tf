terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.36"
    }
  }
}

locals {
  tags = merge(
    var.tags,
    {
      Module = "rstuhlmuller/terragrunt-catalog/kubernetes_namespace"
    }
  )
}
