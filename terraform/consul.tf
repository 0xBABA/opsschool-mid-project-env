resource "aws_instance" "consul_server" {
  count                       = var.num_consul_servers
  ami                         = data.aws_ami.ubuntu-18.id
  instance_type               = var.consul_instance_type
  key_name                    = aws_key_pair.project_key.key_name
  iam_instance_profile        = aws_iam_instance_profile.consul-join.name
  subnet_id                   = element(module.vpc.private_subnet_id, count.index)
  associate_public_ip_address = false

  vpc_security_group_ids = [
    aws_security_group.common_sg.id,
    aws_security_group.consul_sg.id,
    aws_security_group.node_exporter_sg.id,
    aws_security_group.consul_server_sg.id,
    aws_security_group.prometheus_sg.id
  ]

  metadata_options {
    http_endpoint          = "enabled"
    http_tokens            = "optional"
    instance_metadata_tags = "enabled"
  }

  tags = {
    Name                = format("%s-consul-server-${count.index}", var.global_name_prefix)
    consul_server       = "true"
    is_service_instance = "true"
  }
}

resource "aws_security_group" "consul_server_sg" {
  name        = "consul-server-sg"
  description = "Allow consul ui"
  vpc_id      = module.vpc.vpc_id
  tags = {
    Name = format("%s-consul-server-sg", var.global_name_prefix)
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "consul_ui" {
  type              = "ingress"
  from_port         = 8500
  to_port           = 8500
  protocol          = "tcp"
  cidr_blocks       = concat(var.private_subnet_cidrs, var.public_subnet_cidrs)
  description       = "Allow consul UI access from vpc"
  security_group_id = aws_security_group.consul_server_sg.id
}


