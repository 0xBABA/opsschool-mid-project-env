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
  allocated_storage      = var.db_storage
  engine                 = var.db_engine["engine"]
  identifier             = var.db_name
  engine_version         = var.db_engine["version"]
  instance_class         = var.db_instance_class
  port                   = var.db_port
  name                   = var.db_name
  username               = var.db_credentials.admin_user
  password               = var.db_credentials.admin_password
  skip_final_snapshot    = true
  publicly_accessible    = false
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.kandula-db.name
}

output "kandula_db_endpoint" {
  value = format("%s:%s", aws_db_instance.kandula-db.address, aws_db_instance.kandula-db.port)
}

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


resource "local_file" "ansible_psql_role_vars" {
  filename        = var.ansible_psql_role_vars_filepath
  file_permission = "0644"
  sensitive_content = templatefile("${path.module}/templates/db_vars.tftpl", {
    db_name           = var.db_name,
    db_host           = aws_db_instance.kandula-db.address,
    db_admin_user     = var.db_credentials.admin_user,
    db_admin_password = var.db_credentials.admin_password
  })
}

resource "local_file" "db_setup_script" {
  filename        = var.db_setup_script_filepath
  file_permission = "0644"
  sensitive_content = templatefile("${path.module}/templates/setup_db.tftpl", {
    app_user          = var.db_credentials.app_user,
    app_user_password = var.db_credentials.app_user_password
  })
}
