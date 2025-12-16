resource "aws_ssm_parameter" "secret" {
  for_each = var.secrets
  #checkov:skip=CKV_AWS_337: Need to update with project key
  name             = "/homelab/${var.namespace}/${each.key}"
  description      = var.description
  type             = "SecureString"
  value_wo         = "update_me"
  value_wo_version = 0
}

resource "kubernetes_manifest" "external_secret" {
  manifest = {
    apiVersion = "external-secrets.io/v1"
    kind       = "ExternalSecret"
    metadata = {
      name      = var.secret_name
      namespace = var.namespace
    }
    spec = {
      secretStoreRef = {
        name = "parameterstore"
        kind = "ClusterSecretStore"
      }
      refreshPolicy = var.refresh_policy
      data = [for key, value in aws_ssm_parameter.secret : {
        secretKey = key
        remoteRef = {
          key = value.name
        }
      }]
    }
  }
}
