resource "argocd_application" "app" {
  metadata {
    name        = var.name
    namespace   = var.namespace
    annotations = var.annotations
    labels = merge(
      local.tags,
      var.labels
    )
  }

  spec {
    project = var.project
    destination {
      server    = var.server
      namespace = kubernetes_namespace.open_webui.metadata[0].name
    }

    source {
      repo_url        = var.repo_url
      path            = var.path
      target_revision = var.target_revision
      chart           = var.chart
      helm {
        dynamic "parameter" {
          for_each = var.helm_parameters
          content {
            name  = parameter.value.name
            value = parameter.value.value
          }
        }
        values = var.helm_values
      }
    }
    sync_policy {
      dynamic "automated" {
        for_each = var.automated_sync_policy != null ? [1] : []
        content {
          prune       = var.automated_sync_policy.prune
          self_heal   = var.automated_sync_policy.self_heal
          allow_empty = var.automated_sync_policy.allow_empty
        }
      }
    }
  }
}
