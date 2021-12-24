terraform {
  required_version = "1.0.11"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.63"
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
      purpose = "mid-project"
      context = "opsschool"
    }
  }
}
