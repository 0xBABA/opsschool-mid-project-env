resource "aws_security_group" "common_sg" {
  name        = "common-sg"
  description = "Allow ssh, ping and egress traffic"
  vpc_id      = module.vpc.vpc_id
  tags = {
    Name = format("%s-common-sg", var.global_name_prefix)
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  self              = true
  description       = "Allow ssh from the world"
  security_group_id = aws_security_group.common_sg.id
}

resource "aws_security_group_rule" "out" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow all outside security group"
  security_group_id = aws_security_group.common_sg.id

}
resource "aws_security_group_rule" "ping" {
  type              = "ingress"
  from_port         = 8
  to_port           = 0
  protocol          = "icmp"
  self              = true
  description       = "Allow ping"
  security_group_id = aws_security_group.common_sg.id
}
