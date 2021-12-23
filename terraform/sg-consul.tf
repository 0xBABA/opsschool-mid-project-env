resource "aws_security_group" "consul-sg" {
  name        = "consul-sg"
  description = "Allow consul ports, and traffic within the sg"
  vpc_id      = module.vpc.vpc_id
  tags = {
    Name = format("%s-consul-sg", var.global_name_prefix)
  }
  lifecycle {
    create_before_destroy = true
  }
}

#TODO: this should be replaced with a few rules to open ports used by consul: 8600, 8300-8301 (TCP,UDP)
resource "aws_security_group_rule" "consul-sg-rule" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  self              = true
  description       = "Allow all inside security group"
  security_group_id = aws_security_group.consul-sg.id
}

resource "aws_security_group_rule" "allow_consul_ui" {
  type              = "ingress"
  from_port         = 8500
  to_port           = 8500
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow consul UI access from the world"
  security_group_id = aws_security_group.consul-sg.id
}



