variable "region" {
    type = string
    description = "Region used to create subnet and GKE Cluster"
}

variable "zone" {
    type = string
    description = "Zone used to create node pool"
}

variable "project" {
    type = string
    description = "Project ID"
}

variable "cluster_name" {
    type = string
    description = "Name of the GKE Cluster"
}

variable "network" {
    type = string
    description = "name of custom VPC"
}

variable "node_count" {
    type = number
    description = "No of nodes in cluster"
    default = 1
}

variable "machine_type" {
    type = string
    description = "Machine type used for GKE cluster"
    default = "e2-small"
}

variable "preemptibllity" {
    type = bool
    description = "Preamptiblity for machine used in node-pool"
    default = true
}
