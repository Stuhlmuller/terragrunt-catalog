resource "helm_release" "helm" {
  name       = var.name
  repository = var.repository
  chart      = var.chart
  namespace  = var.namespace

  wait                       = true
  atomic                     = true
  cleanup_on_fail            = true
  dependency_update          = true
  disable_openapi_validation = true
  disable_webhooks           = true
  force_update               = true
  replace                    = true
  skip_crds                  = true
  timeout                    = 300
  wait_for_jobs              = true
}
