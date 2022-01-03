resource "aws_s3_bucket" "remote_state_bucket" {
  bucket = var.remote_state_bucket_name
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
    Name = var.remote_state_bucket_name
  }
}

resource "aws_s3_bucket" "opsschool-jenkins-backup" {
  bucket = var.jenkins_bucket_name
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
    Name = var.jenkins_bucket_name
  }
}

