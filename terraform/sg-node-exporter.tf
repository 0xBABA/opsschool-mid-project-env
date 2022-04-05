resource "aws_security_group" "node_exporter_sg" {
  name        = "node-exporter-sg"
  description = "Security group for node-exporter"
  vpc_id      = module.vpc.vpc_id
  tags = {
    Name = format("%s-node-exporter-sg", var.global_name_prefix)
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "node_exporter" {
  type              = "ingress"
  from_port         = 9100
  to_port           = 9100
  protocol          = "tcp"
  self              = true
  description       = "Allow node_exporter port within group"
  security_group_id = aws_security_group.node_exporter_sg.id
}
