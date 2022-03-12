resource "aws_instance" "elk" {
  count                       = var.num_elk_servers
  ami                         = data.aws_ami.ubuntu-18.id
  instance_type               = var.elk_instance_type
  key_name                    = aws_key_pair.project_key.key_name
  iam_instance_profile        = aws_iam_instance_profile.consul-join.name
  subnet_id                   = element(module.vpc.private_subnet_id, count.index + 1)
  associate_public_ip_address = false

  vpc_security_group_ids = [aws_security_group.elk-sg.id]

  metadata_options {
    http_endpoint          = "enabled"
    http_tokens            = "optional"
    instance_metadata_tags = "enabled"
  }

  tags = {
    Name                = format("%s-elk-${count.index}", var.global_name_prefix)
    elk_server          = "true"
    is_service_instance = "true"
  }
}


resource "aws_security_group" "elk-sg" {
  name        = "elk-sg"
  description = "SG for ELK server"
  vpc_id      = module.vpc.vpc_id
  tags = {
    Name = format("%s-elk-sg", var.global_name_prefix)
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "elasticsearch-rest-tcp" {
  type              = "ingress"
  from_port         = 9200
  to_port           = 9200
  protocol          = "tcp"
  cidr_blocks       = concat(var.private_subnet_cidrs, var.public_subnet_cidrs)
  description       = "Allow elk rest tcp"
  security_group_id = aws_security_group.elk-sg.id
}

resource "aws_security_group_rule" "elasticsearch-java-tcp" {
  type              = "ingress"
  from_port         = 9300
  to_port           = 9300
  protocol          = "tcp"
  cidr_blocks       = concat(var.private_subnet_cidrs, var.public_subnet_cidrs)
  description       = "Allow elk java tcp"
  security_group_id = aws_security_group.elk-sg.id
}

resource "aws_security_group_rule" "kibana-tcp" {
  type              = "ingress"
  from_port         = 5601
  to_port           = 5601
  protocol          = "tcp"
  cidr_blocks       = concat(var.private_subnet_cidrs, var.public_subnet_cidrs)
  description       = "Allow kibana ui"
  security_group_id = aws_security_group.elk-sg.id
}

resource "aws_security_group_rule" "logstash-tcp" {
  type              = "ingress"
  from_port         = 5044
  to_port           = 5044
  protocol          = "tcp"
  cidr_blocks       = concat(var.private_subnet_cidrs, var.public_subnet_cidrs)
  description       = "Allow elk rest tcp"
  security_group_id = aws_security_group.elk-sg.id
}

resource "aws_security_group_rule" "ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = concat(var.private_subnet_cidrs, var.public_subnet_cidrs)
  description       = "Allow elk server ssh"
  security_group_id = aws_security_group.elk-sg.id
}

resource "aws_security_group_rule" "elk_node_exporter" {
  type                     = "ingress"
  from_port                = 9100
  to_port                  = 9100
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.monitoring_sg.id
  description              = "Allow prometheus to parse node_exporter metrics"
  security_group_id        = aws_security_group.elk-sg.id
}

resource "aws_security_group_rule" "elk_ping" {
  type              = "ingress"
  from_port         = 8
  to_port           = 0
  protocol          = "icmp"
  cidr_blocks       = concat(var.private_subnet_cidrs, var.public_subnet_cidrs)
  description       = "Allow ping"
  security_group_id = aws_security_group.elk-sg.id
}

resource "aws_security_group_rule" "elk_out" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow all outside security group"
  security_group_id = aws_security_group.elk-sg.id
}

resource "aws_security_group_rule" "ingress_with_self" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "all"
  self              = true
  description       = "Allow ingress with self security group"
  security_group_id = aws_security_group.elk-sg.id
}

resource "aws_security_group_rule" "elk_consul" {
  type                     = "ingress"
  from_port                = 8300
  to_port                  = 8301
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.consul-sg.id
  description              = "Allow consul"
  security_group_id        = aws_security_group.elk-sg.id
}
