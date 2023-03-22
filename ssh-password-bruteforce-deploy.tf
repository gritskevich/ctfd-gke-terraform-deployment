resource "kubernetes_deployment" "ssh_password_bruteforce" {
  metadata {
    name   = "ssh-password-bruteforce"
    labels = {
      app = "ssh-password-bruteforce"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "ssh-password-bruteforce"
      }
    }

    template {
      metadata {
        labels = {
          app = "ssh-password-bruteforce"
        }
      }

      spec {
        container {
          image = "europe-west1-docker.pkg.dev/zoe-asynchronous-communication/ctfd/ssh-password-bruteforce"
          name  = "ssh-password-bruteforce"

          env {
            name  = "SSH_BRUTEFORCE_PASSWORD"
            value = var.ssh_password
          }

          env {
            name  = "SSH_BRUTEFORCE_LOGIN"
            value = var.ssh_login
          }

          port {
            container_port = 22
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "ssh_password_bruteforce" {
  metadata {
    name = "ssh-password-bruteforce"
  }

  spec {
    selector = {
      app = kubernetes_deployment.ssh_password_bruteforce.metadata.0.name
    }

    port {
      name        = "ssh"
      port        = 22
      target_port = 22
    }

    type             = "LoadBalancer"
    load_balancer_ip = var.ssh_ip
  }
}