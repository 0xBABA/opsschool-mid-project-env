variable "kubernetes_version" {
  default     = 1.21
  description = "kubernetes version"
}

locals {
  k8s_service_account_namespace = "opsschool-mid-project-k8s-ns"
  k8s_service_account_name      = "k8s-sa"
  cluster_name                  = "${var.global_name_prefix}-eks-${random_string.suffix.result}"
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}
