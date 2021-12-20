resource "aws_security_group" "common-sg" {
  name        = "common-sg"
  description = "Allow ssh, consul and tcp inbound traffic"
  vpc_id      = module.vpc.vpc_id
  tags = {
    Name = format("%s-common-sg", var.global_name_prefix)
  }
}

resource "aws_security_group_rule" "allow_ssh_in" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow ssh from the world"
  security_group_id = aws_security_group.common-sg.id
}

resource "aws_security_group_rule" "allow_out_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow all outside security group"
  security_group_id = aws_security_group.common-sg.id

}
resource "aws_security_group_rule" "allow_ping_all" {
  type              = "ingress"
  from_port         = 8
  to_port           = 0
  protocol          = "icmp"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow ping"
  security_group_id = aws_security_group.common-sg.id
}
