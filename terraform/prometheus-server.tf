

resource "aws_instance" "prometheus" {
  count                       = 1
  ami                         = data.aws_ami.ubuntu-18.id
  instance_type               = "t2.micro"
  subnet_id                   = element(module.vpc.private_subnet_id, count.index)
  key_name                    = aws_key_pair.project_key.key_name
  associate_public_ip_address = false
  iam_instance_profile        = aws_iam_instance_profile.consul-join.name

  vpc_security_group_ids = [
    aws_security_group.common_sg.id,
    aws_security_group.consul_sg.id,
    aws_security_group.node_exporter_sg.id,
    aws_security_group.prometheus_sg.id
  ]


  metadata_options {
    http_endpoint          = "enabled"
    http_tokens            = "optional"
    instance_metadata_tags = "enabled"
  }

  tags = {
    Name                = format("%s-prometheus-server-${count.index}", var.global_name_prefix)
    is_prometheus       = true
    is_service_instance = true
  }
}

