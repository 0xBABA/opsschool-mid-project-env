resource "aws_instance" "bastion_host" {
  ami                         = data.aws_ami.ubuntu-18.id
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.project_key.key_name
  subnet_id                   = module.vpc.public_subnet_id[0]
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.consul-join.name

  vpc_security_group_ids = [
    aws_security_group.common_sg.id,
    aws_security_group.bastion_sg.id,
    aws_security_group.consul_sg.id
  ]

  metadata_options {
    http_endpoint          = "enabled"
    http_tokens            = "optional"
    instance_metadata_tags = "enabled"
  }

  tags = {
    Name         = format("%s-bastion-host", var.global_name_prefix)
    bastion_host = "true"
    join_consul  = "true"
  }

  #TODO: change to templatefile
  provisioner "local-exec" {
    command = "./scripts/gen_ansible_ssh_config.sh ${self.public_ip}"
  }
}


resource "aws_security_group" "bastion_sg" {
  name        = "bastion-sg"
  description = "Allow ssh and ping"
  vpc_id      = module.vpc.vpc_id
  tags = {
    Name = format("%s-bastion-sg", var.global_name_prefix)
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "bastion_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["${data.http.myip.body}/32"]
  description       = "Allow ssh from owner"
  security_group_id = aws_security_group.bastion_sg.id
}

resource "aws_security_group_rule" "bastion_ping" {
  type              = "ingress"
  from_port         = 8
  to_port           = 0
  protocol          = "icmp"
  cidr_blocks       = ["${data.http.myip.body}/32"]
  description       = "Allow ping from owner"
  security_group_id = aws_security_group.bastion_sg.id
}
