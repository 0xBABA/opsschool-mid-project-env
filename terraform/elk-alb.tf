resource "aws_lb" "elk_alb" {
  name               = format("%s-elk-alb", var.global_name_prefix)
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.elk_alb_sg.id]
  subnets            = module.vpc.public_subnet_id

  tags = {
    Name = format("%s-elk_alb", var.global_name_prefix)
  }

  depends_on = [
    aws_instance.elk
  ]
}

resource "aws_lb_target_group" "elk_alb" {
  name     = format("%s-elk-alb-tg", var.global_name_prefix)
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id

  health_check {
    enabled = true
    path    = "/status"
    port    = 5601
    matcher = "200"
  }

  tags = {
    Name = format("%s-elk-alb-tg", var.global_name_prefix)
  }
}


resource "aws_lb_target_group_attachment" "elk_alb" {
  count            = length(aws_instance.elk)
  target_group_arn = aws_lb_target_group.elk_alb.arn
  target_id        = aws_instance.elk[count.index].id
  port             = 5601
  depends_on = [
    aws_instance.elk
  ]
}

resource "aws_lb_listener" "elk_alb" {
  load_balancer_arn = aws_lb.elk_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.elk_alb.arn
  }

  tags = {
    Name = format("%s-elk_alb_listener", var.global_name_prefix)
  }
}

resource "aws_alb_listener" "elk_https_alb" {
  load_balancer_arn = aws_lb.elk_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.kandula_tls.arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.elk_alb.arn
  }
}

resource "aws_security_group" "elk_alb_sg" {
  name        = "elk-alb-sg"
  description = "Allow kibana ui from world"
  vpc_id      = module.vpc.vpc_id
  tags = {
    Name = format("%s-elk-alb-sg", var.global_name_prefix)
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "elk_alb_http_all" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.elk_alb_sg.id
}

resource "aws_security_group_rule" "elk_alb_https_all" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.elk_alb_sg.id
}

resource "aws_security_group_rule" "elk_alb_out_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.elk_alb_sg.id
}

output "elk_public_dns" {
  value = ["${aws_lb.elk_alb.dns_name}"]
}
