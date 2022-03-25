resource "aws_route53_zone" "kandula" {
  name = format("%s.kandula", var.global_name_prefix)

  vpc {
    vpc_id = module.vpc.vpc_id
  }
}

resource "aws_route53_record" "consul_server" {
  zone_id = aws_route53_zone.kandula.id
  name    = "consul"
  type    = "A"
  ttl     = "300"
  records = aws_instance.consul_server.*.private_ip
}

resource "aws_route53_record" "elk_server" {
  zone_id = aws_route53_zone.kandula.id
  name    = "elk"
  type    = "A"
  ttl     = "300"
  records = aws_instance.elk.*.private_ip
}

resource "aws_route53_record" "jenkins_server" {
  zone_id = aws_route53_zone.kandula.id
  name    = "jenkins.master"
  type    = "A"
  ttl     = "300"
  records = aws_instance.jenkins_server.*.private_ip
}

resource "aws_route53_record" "jenkins_agent" {
  count   = var.num_jenkins_agents
  zone_id = aws_route53_zone.kandula.id
  name    = format("jenkins.agent%s", count.index)
  type    = "A"
  ttl     = "300"
  records = [element(aws_instance.jenkins_agent.*.private_ip, count.index)]
}

resource "aws_route53_record" "prometheus" {
  zone_id = aws_route53_zone.kandula.id
  name    = "prometheus"
  type    = "A"
  ttl     = "300"
  records = aws_instance.prometheus.*.private_ip
}







