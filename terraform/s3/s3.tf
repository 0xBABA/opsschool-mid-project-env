resource "aws_s3_bucket" "remote_state_bucket" {
  bucket = var.bucket_name
  acl    = "private"

  lifecycle {
    prevent_destroy = true
  }

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    Name = var.bucket_name
  }
}

