resource "tls_private_key" "project_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}


resource "aws_key_pair" "project_key" {
  key_name   = "project_key"
  public_key = tls_private_key.project_key.public_key_openssh
}

resource "null_resource" "chmod_400_key" {
  provisioner "local-exec" {
    command = "chmod 0400 ${path.module}/${local_file.private_key.filename}"
  }
}

resource "local_file" "private_key" {
  sensitive_content = tls_private_key.project_key.private_key_pem
  filename          = var.pem_key_name
}
