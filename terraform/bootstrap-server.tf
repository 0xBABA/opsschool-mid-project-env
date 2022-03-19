resource "aws_instance" "bootstrap_server" {
  ami                         = data.aws_ami.ubuntu-18.id
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.project_key.key_name
  subnet_id                   = module.vpc.private_subnet_id[1]
  associate_public_ip_address = false
  iam_instance_profile        = aws_iam_instance_profile.bootstrap_server.name

  vpc_security_group_ids = [
    aws_security_group.common_sg.id,
    aws_security_group.consul_sg.id
  ]

  metadata_options {
    http_endpoint          = "enabled"
    http_tokens            = "optional"
    instance_metadata_tags = "enabled"
  }

  tags = {
    Name             = format("%s-bootstrap-server", var.global_name_prefix)
    bootstrap_server = "true"
    join_consul      = "true"
  }

}



