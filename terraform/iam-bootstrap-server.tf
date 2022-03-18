resource "aws_iam_role" "bootstrap_server" {
  name               = format("%s-bootstrap-server", var.global_name_prefix)
  assume_role_policy = file("${path.module}/iam_policies/assume_role.json")
}

resource "aws_iam_policy" "bootstrap_server" {
  name        = format("%s-bootstrap-server", var.global_name_prefix)
  description = "Allows bootstrap server to describe instances for joining consul DC. And deploy to EKS"
  policy      = file("${path.module}/iam_policies/bootstrap_server_policy.json")
}

resource "aws_iam_policy_attachment" "bootstrap_server" {
  name       = format("%s-bootstrap-server", var.global_name_prefix)
  roles      = [aws_iam_role.bootstrap_server.name]
  policy_arn = aws_iam_policy.bootstrap_server.arn
}

resource "aws_iam_instance_profile" "bootstrap_server" {
  name = format("%s-bootstrap-server", var.global_name_prefix)
  role = aws_iam_role.bootstrap_server.name
}
