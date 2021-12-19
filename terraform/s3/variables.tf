variable "aws_region" {
  default = "us-east-1"
  type    = string
}

variable "bucket_name" {
  default     = "yoad-opsschool-mid-project-state"
  description = "name for the bucket to store the configuration state remotely"
  type        = string
}

