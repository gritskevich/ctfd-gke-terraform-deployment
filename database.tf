resource "kubernetes_service" "mariadb" {
  metadata {
    name = "mariadb"
  }

  spec {
    selector = {
      app = "mariadb"
    }

    port {
      port        = 3306
      target_port = 3306
    }
  }
}

resource "kubernetes_deployment" "mariadb" {
  metadata {
    name = "mariadb"
  }

  spec {
    selector {
      match_labels = {
        app = "mariadb"
      }
    }

    template {
      metadata {
        labels = {
          app = "mariadb"
        }
      }

      spec {
        container {
          name  = "mariadb"
          image = "mariadb:10.4.12"

          env {
            name  = "MYSQL_ROOT_PASSWORD"
            value = "ctfd"
          }

          env {
            name  = "MYSQL_USER"
            value = "ctfd"
          }

          env {
            name  = "MYSQL_PASSWORD"
            value = "ctfd"
          }

          env {
            name  = "MYSQL_DATABASE"
            value = "ctfd"
          }

          volume_mount {
            name       = "mariadb-data"
            mount_path = "/var/lib/mysql"
          }

          args = [
            "mysqld",
            "--character-set-server=utf8mb4",
            "--collation-server=utf8mb4_unicode_ci",
            "--wait_timeout=28800",
            "--log-warnings=0",
          ]
        }

        volume {
          name = "mariadb-data"

          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.mariadb.metadata.0.name
          }
        }
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim" "mariadb" {
  metadata {
    name = "mariadb-data"
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