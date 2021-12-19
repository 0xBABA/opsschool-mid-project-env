## global
variable "aws_region" {
  default = "us-east-1"
  type    = string
}

variable "global_name_prefix" {
  default     = "mid-project"
  type        = string
  description = "1st prefix in the resources' Name tags"
}

## vpc
variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
}

variable "private_subnet_cidrs" {
  description = "CIDR ranges for private subnets"
  default     = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "public_subnet_cidrs" {
  description = "CIDR ranges for private subnets"
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

## ec2 instances
