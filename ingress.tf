terraform {
  required_version = ">= 0.13"
}

provider "kubernetes" {
  # No provider configuration needed here
}

# Executing command to generate kubeconfig
data "external" "get_credentials" {
  program = ["gcloud", "container", "clusters", "get-credentials", "gke-cluster", "--zone", "us-central1-a", "--project", "burner-kumshatr"]
}

# Setting KUBECONFIG environment variable
locals {
  kubeconfig = try(data.external.get_credentials.result.kubeconfig, "")
}

resource "null_resource" "set_kubeconfig" {
  triggers = {
    kubeconfig = local.kubeconfig
  }

  provisioner "local-exec" {
    command = "export KUBECONFIG=${local.kubeconfig}"
  }
}

resource "kubernetes_namespace" "example" {
  metadata {
    name = "app-namespace"
  }
}

resource "kubernetes_deployment" "nginx" {
  metadata {
    name      = "nginx-deployment"
    namespace = kubernetes_namespace.example.metadata[0].name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "nginx"
      }
    }

    template {
      metadata {
        labels = {
          app = "nginx"
        }
      }

      spec {
        container {
          name  = "nginx"
          image = "nginx:1.14.2"

          port {
            container_port = 80
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "nginx" {
  metadata {
    name      = "nginx-service"
    namespace = kubernetes_namespace.example.metadata[0].name
  }

  spec {
    selector = {
      app = "nginx"
    }

    port {
      port        = 80
      target_port = 80
    }

    type = "NodePort"
  }
}

resource "kubernetes_ingress" "nginx" {
  metadata {
    name      = "ingress-external"
    namespace = kubernetes_namespace.example.metadata[0].name
  }

  spec {
    rule {
      http {
        path {
          path     = "/"
          backend {
            service_name = kubernetes_service.nginx.metadata[0].name
            service_port = 80
          }
        }
      }
    }
  }
}
