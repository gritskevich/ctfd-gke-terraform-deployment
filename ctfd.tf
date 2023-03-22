provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_service_v1" "ctfd" {
  metadata {
    name = "ctfd"
  }

  spec {
    selector = {
      app = kubernetes_deployment.ctfd.metadata.0.name
    }

    type = "NodePort"

    port {
      port        = 8080
      target_port = 8000
    }
  }
}

resource "kubernetes_deployment" "ctfd" {
  metadata {
    name   = "ctfd"
    labels = {
      app = "ctfd"
    }
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
          env {
            name  = "DATABASE_URL"
            value = "mysql+pymysql://ctfd:ctfd@mariadb:3306/ctfd"
          }

          env {
            name  = "REDIS_URL"
            value = "redis://redis:6379"
          }

          image = "ctfd/ctfd:latest"
          name  = "ctfd"

          port {
            container_port = 8000
          }

          volume_mount {
            name       = "ctfd-logs"
            mount_path = "/var/log/CTFd"
          }

          volume_mount {
            name       = "ctfd-uploads"
            mount_path = "/var/uploads"
          }

          readiness_probe {
            http_get {
              path = "/healthcheck"
              port = "8000"
            }
          }
        }

        volume {
          name = "ctfd-logs"

          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.ctfd_logs.metadata[0].name
          }
        }

        volume {
          name = "ctfd-uploads"

          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.ctfd_uploads.metadata[0].name
          }
        }
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim" "ctfd_logs" {
  metadata {
    name = "ctfd-logs"
  }

  spec {
    access_modes       = ["ReadWriteOnce"]
    storage_class_name = "standard"

    resources {
      requests = {
        storage = "1Gi"
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim" "ctfd_uploads" {
  metadata {
    name = "ctfd-uploads"
  }

  spec {
    access_modes       = ["ReadWriteOnce"]
    storage_class_name = "standard"

    resources {
      requests = {
        storage = "1Gi"
      }
    }
  }
}
