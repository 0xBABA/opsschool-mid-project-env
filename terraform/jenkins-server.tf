resource "aws_instance" "jenkins_server" {
  ami                         = data.aws_ami.ubuntu-18.id
  instance_type               = "t3.micro"
  key_name                    = aws_key_pair.project_key.key_name
  iam_instance_profile        = aws_iam_instance_profile.jenkins.name
  subnet_id                   = module.vpc.private_subnet_id[0]
  associate_public_ip_address = false

  vpc_security_group_ids = [aws_security_group.jenkins-server-sg.id]

  tags = {
    Name                = format("%s-jenkins-server", var.global_name_prefix)
    jenkins_server      = "true"
    is_service_instance = "true"
  }
}

resource "aws_instance" "jenkins_agent" {
  count                       = var.num_jenkins_agents
  ami                         = data.aws_ami.ubuntu-18.id
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.project_key.key_name
  iam_instance_profile        = aws_iam_instance_profile.jenkins_agents.name
  subnet_id                   = element(module.vpc.private_subnet_id, count.index)
  associate_public_ip_address = false

  vpc_security_group_ids = [aws_security_group.jenkins-server-sg.id]

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

resource "aws_security_group" "jenkins-server-sg" {
  name        = "jenkins-sg"
  description = "Allow jenkins inbound traffic"
  vpc_id      = module.vpc.vpc_id
  tags = {
    Name = format("%s-jenkins-sg", var.global_name_prefix)
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "jenkins_https_all" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.jenkins-server-sg.id
}

resource "aws_security_group_rule" "jenkins_ui_all" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.jenkins-server-sg.id
}

resource "aws_security_group_rule" "jenkins_ssh_all" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.jenkins-server-sg.id
}

resource "aws_security_group_rule" "jenkins_out_all" {
  type              = "egress"
  description       = "Allow all outgoing traffic"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.jenkins-server-sg.id
}

resource "aws_security_group_rule" "jenkins_ping_all" {
  type              = "ingress"
  from_port         = 8
  to_port           = 0
  protocol          = "icmp"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow ping"
  security_group_id = aws_security_group.jenkins-server-sg.id
}

resource "aws_security_group_rule" "jenkins_consul" {
  type                     = "ingress"
  from_port                = 8300
  to_port                  = 8301
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.consul-sg.id
  description              = "Allow ping"
  security_group_id        = aws_security_group.jenkins-server-sg.id
}

resource "aws_security_group_rule" "jenkins_alb" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.jenkins_alb_sg.id
  security_group_id        = aws_security_group.jenkins-server-sg.id
}
