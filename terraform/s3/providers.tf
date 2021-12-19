terraform {
  required_version = "1.0.11"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.63"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      owner   = "yoad"
      purpose = "mid-project"
      context = "opsschool"
    }
  }
}
