resource "aws_instance" "consul_server" {
  count                       = var.num_consul_servers
  ami                         = data.aws_ami.ubuntu-18.id
  instance_type               = var.consul_instance_type
  key_name                    = aws_key_pair.mid_project_key.key_name
  iam_instance_profile        = aws_iam_instance_profile.consul-join.name
  subnet_id                   = element(module.vpc.private_subnet_id, count.index)
  associate_public_ip_address = false

  vpc_security_group_ids = [aws_security_group.consul-sg.id]

  tags = {
    Name                = format("%s-consul-server-${count.index}", var.global_name_prefix)
    consul_server       = "true"
    is_service_instance = "true"
  }
}

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


resource "aws_security_group_rule" "consul-serf-tcp-rule" {
  type              = "ingress"
  from_port         = 8300
  to_port           = 8301
  protocol          = "tcp"
  self              = true
  description       = "Allow serf ports tcp"
  security_group_id = aws_security_group.consul-sg.id
}

resource "aws_security_group_rule" "consul-serf-udp-rule" {
  type              = "ingress"
  from_port         = 8300
  to_port           = 8301
  protocol          = "udp"
  self              = true
  description       = "Allow serf ports udp"
  security_group_id = aws_security_group.consul-sg.id
}

resource "aws_security_group_rule" "consul_ui_all" {
  type              = "ingress"
  from_port         = 8500
  to_port           = 8500
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow consul UI access from the world"
  security_group_id = aws_security_group.consul-sg.id
}

resource "aws_security_group_rule" "consul_ssh_all" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow ssh from the world"
  security_group_id = aws_security_group.consul-sg.id
}

resource "aws_security_group_rule" "consul_out_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow all outside security group"
  security_group_id = aws_security_group.consul-sg.id
}

resource "aws_security_group_rule" "consul_ping_all" {
  type              = "ingress"
  from_port         = 8
  to_port           = 0
  protocol          = "icmp"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow ping"
  security_group_id = aws_security_group.consul-sg.id
}

resource "aws_security_group_rule" "consul_jenkins_server" {
  type                     = "ingress"
  from_port                = 8300
  to_port                  = 8301
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.jenkins-server-sg.id
  description              = "Allow ping"
  security_group_id        = aws_security_group.consul-sg.id
}

resource "aws_security_group_rule" "consul_alb" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.consul_alb_sg.id
  security_group_id        = aws_security_group.consul-sg.id
}
