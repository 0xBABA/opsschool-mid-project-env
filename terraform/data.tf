data "aws_availability_zones" "available" {
  filter {
    name   = "state"
    values = ["available"]
  }
}

data "aws_ami" "ubuntu-18" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
}

# get my external ip 
data "http" "myip" {
  url = "http://ifconfig.me"
}

data "aws_secretsmanager_secret" "kandula_db" {
  name = var.db_secret_name
}

data "aws_secretsmanager_secret_version" "kandula_db" {
  secret_id = data.aws_secretsmanager_secret.kandula_db.id
}
