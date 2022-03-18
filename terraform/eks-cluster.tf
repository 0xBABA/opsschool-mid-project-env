module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "17.24.0"
  cluster_name    = local.cluster_name
  cluster_version = var.kubernetes_version
  subnets         = module.vpc.private_subnet_id
  enable_irsa     = true

  tags = {
    environment = "development"
    k8s         = "true"
  }

  vpc_id = module.vpc.vpc_id

  worker_groups = [
    {
      name                          = "worker-group-1"
      instance_type                 = "t3.medium"
      additional_userdata           = "echo opsschool project"
      asg_desired_capacity          = 2
      additional_security_group_ids = [aws_security_group.all_worker_mgmt.id, aws_security_group.consul_sg.id]
    },
    {
      name                          = "worker-group-2"
      instance_type                 = "t3.large"
      additional_userdata           = "echo opsschool project"
      asg_desired_capacity          = 2
      additional_security_group_ids = [aws_security_group.all_worker_mgmt.id, aws_security_group.consul_sg.id]
    }
  ]

  manage_aws_auth = true
  map_users = [
    {
      groups   = ["system:masters"]
      userarn  = aws_instance.jenkins_agent[0].arn
      username = aws_instance.jenkins_agent[0].id
    },
    {
      groups   = ["system:masters"]
      userarn  = aws_instance.jenkins_agent[1].arn
      username = aws_instance.jenkins_agent[1].id
    }
  ]

  map_roles = [
    {
      rolearn  = aws_iam_role.jenkins_agents.arn
      username = "system:node:{{EC2PrivateDNSName}}"
      groups : ["system:masters"]
    }
  ]

}

data "aws_eks_cluster" "eks" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "eks" {
  name = module.eks.cluster_id
}
