## global
variable "aws_region" {
  default = "us-east-1"
  type    = string
}

variable "global_name_prefix" {
  default     = "project"
  type        = string
  description = "1st prefix in the resources' Name tags"
}

variable "pem_key_name" {
  default     = "opsschool_project.pem"
  type        = string
  description = "name of ssh key to attach to instances"
}


