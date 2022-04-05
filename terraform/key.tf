## SSH 
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

## TLS
resource "tls_private_key" "kandula_tls" {
  algorithm = "RSA"
}

resource "tls_self_signed_cert" "kandula_tls" {
  key_algorithm   = "RSA"
  private_key_pem = tls_private_key.kandula_tls.private_key_pem

  subject {
    common_name  = format("%s.kandula", var.global_name_prefix)
    organization = "opsschool project"
  }

  validity_period_hours = 24

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

resource "aws_acm_certificate" "kandula_tls" {
  private_key      = tls_private_key.kandula_tls.private_key_pem
  certificate_body = tls_self_signed_cert.kandula_tls.cert_pem
}

output "kandula_tls_arn" {
  value = aws_acm_certificate.kandula_tls.arn
}
