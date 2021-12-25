resource "aws_security_group" "jenkins-sg" {
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

#TODO: do i need this if this is in private subnet?
resource "aws_security_group_rule" "allow_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.jenkins-sg.id
}

resource "aws_security_group_rule" "allow_jenkins_web_ui" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.jenkins-sg.id
}

resource "aws_security_group_rule" "allow_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.jenkins-sg.id
}

resource "aws_security_group_rule" "allow_all_outgoing_traffic" {
  type              = "egress"
  description       = "Allow all outgoing traffic"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.jenkins-sg.id
}
