provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_deployment" "ctfd" {
  metadata {
    name = "ctfd"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "ctfd"
      }
    }

    template {
      metadata {
        labels = {
          app = "ctfd"
        }
      }

      spec {
        container {
          image = "ctfd/ctfd:latest"
          name  = "ctfd"

          port {
            container_port = 8000
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "ctfd" {
  metadata {
    name = "ctfd"
  }

  spec {
    selector = {
      app = "ctfd"
    }

    type = "LoadBalancer"

    load_balancer_ip = "34.78.211.149"

    port {
      port        = 80
      target_port = 8000
    }
  }
}
