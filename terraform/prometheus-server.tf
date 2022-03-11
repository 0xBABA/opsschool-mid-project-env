resource "aws_security_group" "monitoring_sg" {
  name        = "prometheus-sg"
  description = "Security group for prometheus server"
  #TODO: this shouldn't be hardcoded when integrated in project
  vpc_id = module.vpc.vpc_id
  tags = {
    Name = format("%s-prometheus-sg", var.global_name_prefix)
  }
  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_security_group_rule" "prometheus_out" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow all outside security group"
  security_group_id = aws_security_group.monitoring_sg.id
}

resource "aws_security_group_rule" "prometheus_ping" {
  type              = "ingress"
  from_port         = 8
  to_port           = 0
  protocol          = "icmp"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow ping"
  security_group_id = aws_security_group.monitoring_sg.id
}

resource "aws_security_group_rule" "prometheus_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow ssh from the prometheus-sg"
  security_group_id = aws_security_group.monitoring_sg.id
}

# Allow all traffic to HTTP port 3000
resource "aws_security_group_rule" "prometheus_grafana" {
  type              = "ingress"
  from_port         = 3000
  to_port           = 3000
  protocol          = "TCP"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow grafana ui from anywhere"
  security_group_id = aws_security_group.monitoring_sg.id
}

# Allow all traffic to HTTP port 9090
resource "aws_security_group_rule" "prometheus_ui" {
  type              = "ingress"
  from_port         = 9090
  to_port           = 9090
  protocol          = "TCP"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow prometheus ui from anywhere"
  security_group_id = aws_security_group.monitoring_sg.id
}

resource "aws_security_group_rule" "prometheus_consul" {
  type                     = "ingress"
  from_port                = 8300
  to_port                  = 8301
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.consul-sg.id
  description              = "Allow ping"
  security_group_id        = aws_security_group.monitoring_sg.id
}

resource "aws_instance" "prometheus" {
  count                       = 1
  ami                         = data.aws_ami.ubuntu-18.id
  instance_type               = "t2.micro"
  subnet_id                   = element(module.vpc.private_subnet_id, count.index)
  vpc_security_group_ids      = [aws_security_group.monitoring_sg.id]
  key_name                    = aws_key_pair.project_key.key_name
  associate_public_ip_address = false
  iam_instance_profile        = aws_iam_instance_profile.consul-join.name

  metadata_options {
    instance_metadata_tags = "enabled"
  }

  tags = {
    Name                = format("%s-prometheus-server-${count.index}", var.global_name_prefix)
    is_prometheus       = true
    is_service_instance = true
  }
}

