variable "aws_region" {
  default = "us-east-1"
  type    = string
}

variable "remote_state_bucket_name" {
  default     = "yoad-opsschool-mid-project-state"
  description = "name for the bucket to store the configuration state remotely"
  type        = string
}

variable "jenkins_bucket_name" {
  default     = "yoad-opsschool-mid-project-jenkins"
  description = "name for the bucket to store jenkins configuration"
  type        = string
}
