resource "kubernetes_namespace" "namespace" {
  metadata {
    name          = var.name
    generate_name = var.generate_name

    labels      = var.labels
    annotations = var.annotations
  }

  timeouts {
    delete = "2m"
  }
}
