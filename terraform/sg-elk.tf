resource "aws_security_group" "elk_sg" {
  name        = "elk-sg"
  description = "SG for ELK"
  vpc_id      = module.vpc.vpc_id
  tags = {
    Name = format("%s-elk-sg", var.global_name_prefix)
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "elasticsearch_rest_tcp" {
  type              = "ingress"
  from_port         = 9200
  to_port           = 9200
  protocol          = "tcp"
  cidr_blocks       = concat(var.private_subnet_cidrs, var.public_subnet_cidrs)
  description       = "Allow elk rest tcp"
  security_group_id = aws_security_group.elk_sg.id
}

resource "aws_security_group_rule" "elasticsearch_java_tcp" {
  type              = "ingress"
  from_port         = 9300
  to_port           = 9300
  protocol          = "tcp"
  cidr_blocks       = concat(var.private_subnet_cidrs, var.public_subnet_cidrs)
  description       = "Allow elk java tcp"
  security_group_id = aws_security_group.elk_sg.id
}

resource "aws_security_group_rule" "kibana_tcp" {
  type              = "ingress"
  from_port         = 5601
  to_port           = 5601
  protocol          = "tcp"
  cidr_blocks       = concat(var.private_subnet_cidrs, var.public_subnet_cidrs)
  description       = "Allow kibana ui"
  security_group_id = aws_security_group.elk_sg.id
}

#TODO: might not be required if using only filebeat
# resource "aws_security_group_rule" "logstash_tcp" {
#   type              = "ingress"
#   from_port         = 5044
#   to_port           = 5044
#   protocol          = "tcp"
#   cidr_blocks       = concat(var.private_subnet_cidrs, var.public_subnet_cidrs)
#   description       = "Allow elk rest tcp"
#   security_group_id = aws_security_group.elk_sg.id
# }

# resource "aws_security_group_rule" "elk_alb" {
#   type                     = "ingress"
#   from_port                = 80
#   to_port                  = 80
#   protocol                 = "tcp"
#   source_security_group_id = aws_security_group.elk_alb_sg.id
#   security_group_id        = aws_security_group.elk_sg.id
# }
