module "vpc" {
  source               = "github.com/0xBABA/terraform-aws-vpc.git?ref=v0.0.5"
  global_name_prefix   = var.global_name_prefix
  azs                  = data.aws_availability_zones.available.names
  vpc_cidr_block       = var.vpc_cidr_block
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}
