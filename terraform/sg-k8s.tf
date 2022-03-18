
resource "aws_security_group" "all_worker_mgmt" {
  name_prefix = "all_worker_management"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = concat(var.private_subnet_cidrs, var.public_subnet_cidrs)
  }
  lifecycle {
    create_before_destroy = true
  }
}

