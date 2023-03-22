resource "kubernetes_deployment" "port_scan" {
  metadata {
    name   = "port-scan"
    labels = {
      app = "port-scan"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "port-scan"
      }
    }

    template {
      metadata {
        labels = {
          app = "port-scan"
        }
      }

      spec {
        container {
          image = "europe-west1-docker.pkg.dev/zoe-asynchronous-communication/ctfd/port"
          name  = "port-scan"

          env {
            name  = "PORT_EXPOSE_FLAG1"
            value = var.port_number
          }

          env {
            name  = "PORT_EXPOSE_FLAG2"
            value = var.port_message
          }

          port {
            container_port = 22
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "port_scan" {
  metadata {
    name = "port-scan"
  }

  spec {
    selector = {
      app = kubernetes_deployment.port_scan.metadata.0.name
    }

    port {
      name        = "port"
      port        = var.port_number
      target_port = var.port_number
    }

    type = "LoadBalancer"
    load_balancer_ip = var.port_ip
  }
}