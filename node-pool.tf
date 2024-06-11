resource "google_service_account" "kubernetes" {
  account_id = "kubernetes"
  display_name = "kubernetes"
}

resource "google_container_node_pool" "dev_preemptible_nodes" {
  name       = "dev-node-pool"
  location   = var.zone
  cluster    = google_container_cluster.primary.id
  node_count = var.node_count

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  autoscaling {
    min_node_count = 1
    max_node_count = 10
  }

  node_config {
    preemptible  = true
    machine_type = var.machine_type

    labels = {
      env = "dev"
    }

    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    service_account = google_service_account.kubernetes.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}
