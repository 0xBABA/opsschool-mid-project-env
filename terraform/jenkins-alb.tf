resource "aws_lb" "jenkins_alb" {
  name               = format("%s-jenkins-alb", var.global_name_prefix)
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.jenkins_alb_sg.id]
  subnets            = module.vpc.public_subnet_id

  tags = {
    Name = format("%s-jenkins_alb", var.global_name_prefix)
  }

  depends_on = [
    aws_instance.jenkins_server
  ]
}

resource "aws_lb_target_group" "jenkins_alb" {
  name     = format("%s-jenkins-alb-tg", var.global_name_prefix)
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id

  health_check {
    enabled = true
    path    = "/login"
    port    = 8080
  }

  tags = {
    Name = format("%s-jenkins-alb-tg", var.global_name_prefix)
  }
}

resource "aws_lb_target_group_attachment" "jenkins_alb" {
  target_group_arn = aws_lb_target_group.jenkins_alb.arn
  target_id        = aws_instance.jenkins_server.id
  port             = 8080
  depends_on = [
    aws_instance.jenkins_server
  ]
}

resource "aws_lb_listener" "jenkins_alb" {
  load_balancer_arn = aws_lb.jenkins_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.jenkins_alb.arn
  }

  tags = {
    Name = format("%s-jenkins_alb_listener", var.global_name_prefix)
  }
}

resource "aws_alb_listener" "jenkins_https_alb" {
  load_balancer_arn = aws_lb.jenkins_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.kandula_tls.arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.jenkins_alb.arn
  }
}

resource "aws_security_group" "jenkins_alb_sg" {
  name        = "jenkins-alb-sg"
  description = "Allow jenkins inbound traffic from world"
  vpc_id      = module.vpc.vpc_id
  tags = {
    Name = format("%s-jenkins-alb-sg", var.global_name_prefix)
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "jenkins_alb_http_all" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.jenkins_alb_sg.id
}

resource "aws_security_group_rule" "jenkins_alb_https_all" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.jenkins_alb_sg.id
}

resource "aws_security_group_rule" "jenkins_alb_out_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.jenkins_alb_sg.id
}



output "jenkins_public_dns" {
  value = ["${aws_lb.jenkins_alb.dns_name}"]
}
