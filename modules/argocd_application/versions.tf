terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.36"
    }
    argocd = {
      source  = "argoproj-labs/argocd"
      version = "~> 7.8"
    }
  }
}

locals {
  tags = merge(
    var.tags,
    {
      Module = "rstuhlmuller/terragrunt-catalog/argocd_application"
    }
  )
}
