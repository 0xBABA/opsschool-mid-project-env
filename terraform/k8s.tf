resource "kubernetes_namespace" "k8s_ns" {
  metadata {
    annotations = {
      name = local.k8s_service_account_namespace
    }

    labels = {
      mylabel = "label-value"
    }

    name = local.k8s_service_account_namespace
  }
}

resource "kubernetes_service_account" "k8s_sa" {
  metadata {
    name      = local.k8s_service_account_name
    namespace = kubernetes_namespace.k8s_ns.id
    annotations = {
      "eks.amazonaws.com/role-arn" = module.iam_assumable_role_admin.iam_role_arn
    }
  }
  depends_on = [module.eks]
}
