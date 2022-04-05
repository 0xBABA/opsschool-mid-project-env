resource "aws_security_group" "prometheus_sg" {
  name        = "prometheus-sg"
  description = "Security group for prometheus server"
  vpc_id      = module.vpc.vpc_id
  tags = {
    Name = format("%s-prometheus-sg", var.global_name_prefix)
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "prometheus_grafana" {
  type              = "ingress"
  from_port         = 3000
  to_port           = 3000
  protocol          = "tcp"
  cidr_blocks       = concat(var.private_subnet_cidrs, var.public_subnet_cidrs)
  description       = "Allow grafana ui from vpc"
  security_group_id = aws_security_group.prometheus_sg.id
}

resource "aws_security_group_rule" "prometheus_ui" {
  type              = "ingress"
  from_port         = 9090
  to_port           = 9090
  protocol          = "tcp"
  cidr_blocks       = concat(var.private_subnet_cidrs, var.public_subnet_cidrs)
  description       = "Allow prometheus ui from vpc"
  security_group_id = aws_security_group.prometheus_sg.id
}
