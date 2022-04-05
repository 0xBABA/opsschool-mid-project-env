resource "aws_security_group" "jenkins_sg" {
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
  cidr_blocks       = concat(var.private_subnet_cidrs, var.public_subnet_cidrs)
  security_group_id = aws_security_group.jenkins_sg.id
}

resource "aws_security_group_rule" "jenkins_ui_all" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = concat(var.private_subnet_cidrs, var.public_subnet_cidrs)
  security_group_id = aws_security_group.jenkins_sg.id
}

# resource "aws_security_group_rule" "jenkins_alb" {
#   type                     = "ingress"
#   from_port                = 80
#   to_port                  = 80
#   protocol                 = "tcp"
#   source_security_group_id = aws_security_group.jenkins_alb_sg.id
#   security_group_id        = aws_security_group.jenkins_sg.id
# }
