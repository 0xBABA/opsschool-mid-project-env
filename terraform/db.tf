# get my external ip - should be redundant for project
data "http" "myip" {
  url = "http://ifconfig.me"
}

resource "aws_db_subnet_group" "kandula-db" {
  name       = format("%s-db-sn-grp", var.global_name_prefix)
  subnet_ids = module.vpc.private_subnet_id

  tags = {
    Name = format("%s-db-sn-grp", var.global_name_prefix)
  }
}

resource "aws_db_instance" "kandula-db" {
  allocated_storage   = var.db_storage
  engine              = var.db_engine["engine"]
  identifier          = var.db_name
  engine_version      = var.db_engine["version"]
  instance_class      = var.db_instance_class
  port                = var.db_port
  name                = var.db_name
  username            = var.db_credentials.user
  password            = var.db_credentials.password
  skip_final_snapshot = true
  #TODO: in the real project this should be in a provate SN and not publicly accessible.
  # will required aws_db_subnet_group resource
  publicly_accessible    = false
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.kandula-db.name
}

output "kandula_db_endpoint" {
  value = format("%s:%s", aws_db_instance.kandula-db.address, aws_db_instance.kandula-db.port)
}


#TODO: with db not publicly accessable this should run from the bastion host
# aws_instance.bastion_host.public_ip
# locals {
#   psql_cmd = "/Applications/Postgres.app/Contents/Versions/latest/bin/psql -h ${aws_db_instance.kandula-db.address} -p ${aws_db_instance.kandula-db.port} -U \"${aws_db_instance.kandula-db.username}\" -d ${aws_db_instance.kandula-db.name} -f \"./scripts/setup_db.sql\" "
# }
# resource "null_resource" "db_setup" {

#   provisioner "local-exec" {
#     # command = "/Applications/Postgres.app/Contents/Versions/latest/bin/psql -h ${aws_db_instance.kandula-db.address} -p ${aws_db_instance.kandula-db.port} -U \"${aws_db_instance.kandula-db.username}\" -d ${aws_db_instance.kandula-db.name} -f \"./scripts/setup_db.sql\" "
#     command = "ssh -i ${var.pem_key_name} -f -N -L 5433:${aws_db_instance.kandula-db.address}:${aws_db_instance.kandula-db.port} ec2-user@${aws_instance.bastion_host.public_ip} -v '${local.psql_cmd}'"
#     environment = {
#       PGPASSWORD = "${var.db_credentials.password}"
#     }
#   }
# }


resource "aws_security_group" "rds_sg" {
  name        = "rds-sg"
  description = "Allow postgres ports"
  # for project vpc should be from module
  vpc_id = module.vpc.vpc_id
  tags = {
    Name = format("%s-rds-sg", var.global_name_prefix)
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "rds_psql_from_common_sg" {
  type                     = "ingress"
  from_port                = aws_db_instance.kandula-db.port
  to_port                  = aws_db_instance.kandula-db.port
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.common-sg.id
  description              = "Allow psql port tcp"
  security_group_id        = aws_security_group.rds_sg.id
}

resource "aws_security_group_rule" "rds_psql_from_eks" {
  type                     = "ingress"
  from_port                = aws_db_instance.kandula-db.port
  to_port                  = aws_db_instance.kandula-db.port
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.all_worker_mgmt.id
  description              = "Allow psql port tcp"
  security_group_id        = aws_security_group.rds_sg.id
}

resource "aws_security_group_rule" "rds_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow ssh from my ip"
  security_group_id = aws_security_group.rds_sg.id
}

## create AWS Secret Manager for DB Credentials
# resource "aws_secretsmanager_secret" "rds_admin_creds" {
#   name = var.db_name
#   recovery_window_in_days = 0
# }
# resource "aws_secretsmanager_secret_version" "rds_admin_creds" {
#   secret_id     = aws_secretsmanager_secret.rds_admin_creds.id
#   secret_string = jsonencode(var.db_credentials)
# }
# data "aws_secretsmanager_secret" "rds_admin_creds" {
#   name = var.db_secret_name
# }

# data "aws_secretsmanager_secret_version" "rds_admin_creds" {
#   secret_id = data.aws_secretsmanager_secret.rds_admin_creds.id
# }
