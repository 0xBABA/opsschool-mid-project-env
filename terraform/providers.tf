terraform {
  required_version = "1.0.11"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      # version = "~> 3.63"
      version = "~> 3.72.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">=2.7.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.1.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.1.0"
    }
    template = {
      source  = "hashicorp/template"
      version = "~> 2.2.0"
    }
  }
  backend "s3" {
    bucket = "yoad-opsschool-mid-project-state"
    key    = "mid_project_state/mid_proj.tfstate"
    region = "us-east-1"
  }
}

##################################################################################
# PROVIDERS
##################################################################################
provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      owner   = "yoad"
      purpose = "project"
      context = "opsschool"
    }
  }
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.eks.token
}
