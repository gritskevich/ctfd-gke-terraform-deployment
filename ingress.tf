resource "kubernetes_ingress_v1" "ctfd" {
  metadata {
    name        = "ctfd-ingress"
    annotations = {
      "kubernetes.io/ingress.class" = "gce"
      "kubernetes.io/ingress.global-static-ip-name" = "ctfd"
      "networking.gke.io/v1beta1.FrontendConfig"    = kubernetes_manifest.my_frontend_config.manifest.metadata.name
    }
  }
  spec {
    tls {
      secret_name = "ctfd-tls"
    }
    default_backend {
      service {
        name = "ctfd"
        port {
          number = 8080
        }
      }
    }

     rule {
       host = "insecure.hackingame.com"

      http {
        path {
          backend {
            service {
              name = "insecure"
              port {
                number = 8080
              }
            }
          }

          path = "/*"
        }
      }
    }

  }
}

resource "kubernetes_manifest" "my_frontend_config" {
  manifest = {
    apiVersion = "networking.gke.io/v1beta1"
    kind       = "FrontendConfig"
    metadata   = {
      name      = "my-frontend-config"
      namespace = "default"
    }
    spec = {
      redirectToHttps = {
        enabled          = true
        responseCodeName = "MOVED_PERMANENTLY_DEFAULT"
      }
    }
  }
}
