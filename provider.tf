terraform {
  backend "gcs" {
    bucket = "burner-tf-state1"
    prefix = "terraform/state"
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.10.0"
    }
  }
}

provider "google" {
  project = var.project
  region  = var.region
}
