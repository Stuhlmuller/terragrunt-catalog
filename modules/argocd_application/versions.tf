terraform {
  required_providers {
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
