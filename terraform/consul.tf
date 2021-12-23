resource "aws_instance" "consul_server" {
  count                = var.num_consul_servers
  ami                  = data.aws_ami.ubuntu-18.id
  instance_type        = var.consul_instance_type
  key_name             = aws_key_pair.mid_project_key.key_name
  iam_instance_profile = aws_iam_instance_profile.consul-join.name
  # TODO: move consul servers in private subnet and allow access via ALB
  subnet_id                   = element(module.vpc.private_subnet_id, count.index)
  associate_public_ip_address = false

  vpc_security_group_ids = [aws_security_group.common-sg.id, aws_security_group.consul-sg.id]

  tags = {
    Name          = format("%s-consul-server-${count.index}", var.global_name_prefix)
    consul_server = "true"
  }

}


