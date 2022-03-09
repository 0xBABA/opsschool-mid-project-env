resource "aws_instance" "bastion_host" {
  ami                         = data.aws_ami.ubuntu-18.id
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.project_key.key_name
  subnet_id                   = module.vpc.public_subnet_id[0]
  associate_public_ip_address = true

  vpc_security_group_ids = [aws_security_group.common-sg.id]

  tags = {
    Name         = format("%s-bastion-host", var.global_name_prefix)
    bastion_host = "true"
  }

  #TODO: change to templatefile
  provisioner "local-exec" {
    command = "./scripts/gen_ansible_ssh_config.sh ${self.public_ip}"
  }
}

