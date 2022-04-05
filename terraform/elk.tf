resource "aws_instance" "elk" {
  count                       = var.num_elk_servers
  ami                         = data.aws_ami.ubuntu-18.id
  instance_type               = var.elk_instance_type
  key_name                    = aws_key_pair.project_key.key_name
  iam_instance_profile        = aws_iam_instance_profile.consul-join.name
  subnet_id                   = element(module.vpc.private_subnet_id, count.index + 1)
  associate_public_ip_address = false

  vpc_security_group_ids = [
    aws_security_group.common_sg.id,
    aws_security_group.consul_sg.id,
    aws_security_group.node_exporter_sg.id,
    aws_security_group.elk_sg.id
  ]

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


