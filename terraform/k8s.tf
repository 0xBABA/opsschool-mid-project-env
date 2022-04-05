resource "kubernetes_service_account" "kandula" {
  metadata {
    name      = local.k8s_service_account_name
    namespace = local.k8s_service_account_namespace
    annotations = {
      "eks.amazonaws.com/role-arn" = module.iam_assumable_role_admin.iam_role_arn
    }
  }
  depends_on = [module.eks]
}

resource "kubernetes_namespace" "kandula" {
  metadata {
    annotations = {
      name = local.k8s_service_account_namespace
    }

    name = local.k8s_service_account_namespace
  }
  depends_on = [module.eks]
}

