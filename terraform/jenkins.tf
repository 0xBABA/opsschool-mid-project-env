resource "aws_instance" "jenkins_server" {
  ami                         = data.aws_ami.ubuntu-18.id
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.mid_project_key.key_name
  subnet_id                   = module.vpc.private_subnet_id[0]
  associate_public_ip_address = false

  vpc_security_group_ids = [aws_security_group.common-sg.id, aws_security_group.jenkins-sg.id]

  tags = {
    Name                = format("%s-jenkins-server", var.global_name_prefix)
    jenkins_server      = "true"
    is_service_instance = "true"
  }
}
