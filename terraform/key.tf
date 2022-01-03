resource "tls_private_key" "mid_project_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "mid_project_key" {
  key_name   = "mid_project_key"
  public_key = tls_private_key.mid_project_key.public_key_openssh
}

resource "null_resource" "chmod_400_key" {
  provisioner "local-exec" {
    command = "chmod 400 ${path.module}/${local_file.private_key.filename}"
  }
}

resource "local_file" "private_key" {
  sensitive_content = tls_private_key.mid_project_key.private_key_pem
  filename          = var.pem_key_name
}
