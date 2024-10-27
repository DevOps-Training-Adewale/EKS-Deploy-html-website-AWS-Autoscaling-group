resource "kubernetes_horizontal_pod_autoscaler" "my_html_app" {
  metadata {
    name = "html-app-hpa"
  }

  spec {
    scale_target_ref {
      api_version = "apps/v1"
      kind        = "Deployment"
      name        = "html-app"
    }
    min_replicas = 1
    max_replicas = 5
    metric {
      type = "Resource"
      resource {
        name = "cpu"
        target {
          type    = "Utilization"
          average_utilization = 50
        }
      }
    }
  }
}
