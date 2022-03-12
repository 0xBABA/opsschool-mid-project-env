variable "elk_instance_type" {
  type        = string
  description = "instance type for elk hosting"
  default     = "t2.micro"
}

variable "num_elk_servers" {
  type        = number
  description = "number of elk instances to provision"
  default     = 1
}
