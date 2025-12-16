terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.0"
    }
  }
}
locals {
  tags = merge(
    var.tags,
    {
      Module = "rstuhlmuller/terragrunt-catalog/helm"
    }
  )
}
