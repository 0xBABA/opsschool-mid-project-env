# Create an IAM role for the auto-join
resource "aws_iam_role" "consul-join" {
  name               = "opsschool-project-consul-join"
  assume_role_policy = file("${path.module}/iam_policies/assume_role.json")
}

# Create the policy
resource "aws_iam_policy" "consul-join" {
  name        = "opsschool-project-consul-join"
  description = "Allows Consul nodes to describe instances for joining."
  policy      = file("${path.module}/iam_policies/describe_instances.json")
}

# Attach the policy
resource "aws_iam_policy_attachment" "consul-join" {
  name       = "opsschool-project-consul-join"
  roles      = [aws_iam_role.consul-join.name]
  policy_arn = aws_iam_policy.consul-join.arn
}

# Create the instance profile
resource "aws_iam_instance_profile" "consul-join" {
  name = "opsschool-project-consul-join"
  role = aws_iam_role.consul-join.name
}


output "consul-join-iam-role" {
  description = "arn for consul-join iam role"
  value       = aws_iam_role.consul-join.arn
}
