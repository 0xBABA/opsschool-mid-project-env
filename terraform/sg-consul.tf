resource "aws_security_group" "consul_sg" {
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


resource "aws_security_group_rule" "consul_serf_tcp" {
  type              = "ingress"
  from_port         = 8300
  to_port           = 8302
  protocol          = "tcp"
  self              = true
  description       = "Allow serf ports tcp"
  security_group_id = aws_security_group.consul_sg.id
}

resource "aws_security_group_rule" "consul_serf_udp" {
  type              = "ingress"
  from_port         = 8300
  to_port           = 8302
  protocol          = "udp"
  self              = true
  description       = "Allow serf ports udp"
  security_group_id = aws_security_group.consul_sg.id
}

resource "aws_security_group_rule" "consul_dns_tcp" {
  type              = "ingress"
  from_port         = 8600
  to_port           = 8600
  protocol          = "tcp"
  self              = true
  description       = "Allow serf ports udp"
  security_group_id = aws_security_group.consul_sg.id
}

resource "aws_security_group_rule" "consul_dns_udp" {
  type              = "ingress"
  from_port         = 8600
  to_port           = 8600
  protocol          = "udp"
  self              = true
  description       = "Allow serf ports udp"
  security_group_id = aws_security_group.consul_sg.id
}
