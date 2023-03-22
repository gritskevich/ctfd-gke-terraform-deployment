resource "kubernetes_deployment" "insecure" {
  metadata {
    name   = "insecure"
    labels = {
      app = "insecure"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "insecure"
      }
    }

    template {
      metadata {
        labels = {
          app = "insecure"
        }
      }

      spec {
        container {
          image = "europe-west1-docker.pkg.dev/zoe-asynchronous-communication/ctfd/insecure"
          name  = "insecure"

          port {
            container_port = 80
          }
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "insecure" {
  metadata {
    name = "insecure"
  }

  spec {
    selector = {
      app = kubernetes_deployment.insecure.metadata.0.name
    }

    type = "NodePort"

    port {
      port        = 8080
      target_port = 80
    }
  }
}
