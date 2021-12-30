# Create an IAM role for the auto-join
resource "aws_iam_role" "jenkins" {
  name               = "opsschool-mid-project-jenkins"
  assume_role_policy = file("${path.module}/iam_policies/assume_role.json")
}

# Create the policy
resource "aws_iam_policy" "jenkins" {
  name        = "opsschool-mid-project-jenkins"
  description = "Allows jenkins instances to describe instances for joining consul DC."
  policy      = file("${path.module}/iam_policies/jenkins_policy.json")
}

# Attach the policy
resource "aws_iam_policy_attachment" "jenkins" {
  name       = "opsschool-mid-project-jenkins"
  roles      = [aws_iam_role.jenkins.name]
  policy_arn = aws_iam_policy.jenkins.arn
}

# Create the instance profile
resource "aws_iam_instance_profile" "jenkins" {
  name = "opsschool-mid-project-jenkins"
  role = aws_iam_role.jenkins.name
}
