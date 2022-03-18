variable "kubernetes_version" {
  default     = 1.21
  description = "kubernetes version"
}

locals {
  k8s_service_account_namespace = "kandula"
  k8s_service_account_name      = "kandula-sa"
  cluster_name                  = "${var.global_name_prefix}-eks-${random_string.suffix.result}"
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}

variable "bootstrap_role_vars_file" {
  description = "file path for bootstrap ansible role vars"
  type        = string
  default     = "../ansible/roles/bootstrap/vars/main.yml"
}
