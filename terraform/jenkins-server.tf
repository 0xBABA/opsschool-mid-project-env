resource "aws_instance" "jenkins_server" {
  ami                         = data.aws_ami.ubuntu-18.id
  instance_type               = "t3.micro"
  key_name                    = aws_key_pair.project_key.key_name
  iam_instance_profile        = aws_iam_instance_profile.jenkins.name
  subnet_id                   = module.vpc.private_subnet_id[0]
  associate_public_ip_address = false

  vpc_security_group_ids = [
    aws_security_group.common_sg.id,
    aws_security_group.consul_sg.id,
    aws_security_group.node_exporter_sg.id,
    aws_security_group.jenkins_sg.id
  ]

  metadata_options {
    http_endpoint          = "enabled"
    http_tokens            = "optional"
    instance_metadata_tags = "enabled"
  }

  tags = {
    Name                = format("%s-jenkins-server", var.global_name_prefix)
    jenkins_server      = "true"
    is_service_instance = "true"
  }
}

resource "aws_instance" "jenkins_agent" {
  count                       = var.num_jenkins_agents
  ami                         = data.aws_ami.ubuntu-18.id
  instance_type               = "t3.small"
  key_name                    = aws_key_pair.project_key.key_name
  iam_instance_profile        = aws_iam_instance_profile.jenkins_agents.name
  subnet_id                   = element(module.vpc.private_subnet_id, count.index)
  associate_public_ip_address = false

  vpc_security_group_ids = [
    aws_security_group.common_sg.id,
    aws_security_group.consul_sg.id,
    aws_security_group.node_exporter_sg.id,
    aws_security_group.jenkins_sg.id
  ]

  metadata_options {
    http_endpoint          = "enabled"
    http_tokens            = "optional"
    instance_metadata_tags = "enabled"
  }

  tags = {
    Name                = format("%s-jenkins-agent-${count.index}", var.global_name_prefix)
    jenkins_agent       = "true"
    is_service_instance = "true"
  }
}

output "jenkins_agents_arn" {
  description = "jenkins agents arns"
  value       = aws_instance.jenkins_agent.*.arn
}




