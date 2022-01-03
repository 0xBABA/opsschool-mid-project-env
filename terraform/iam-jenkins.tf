# Create an IAM role for the auto-join
resource "aws_iam_role" "jenkins" {
  name               = format("%s-jenkins", var.global_name_prefix)
  assume_role_policy = file("${path.module}/iam_policies/assume_role.json")
}

# Create the policy
resource "aws_iam_policy" "jenkins" {
  name        = format("%s-jenkins", var.global_name_prefix)
  description = "Allows jenkins instances to describe instances for joining consul DC."
  policy      = file("${path.module}/iam_policies/jenkins_policy.json")
}

# Attach the policy
resource "aws_iam_policy_attachment" "jenkins" {
  name       = format("%s-jenkins", var.global_name_prefix)
  roles      = [aws_iam_role.jenkins.name]
  policy_arn = aws_iam_policy.jenkins.arn
}

# Create the instance profile
resource "aws_iam_instance_profile" "jenkins" {
  name = format("%s-jenkins", var.global_name_prefix)
  role = aws_iam_role.jenkins.name
}


resource "aws_iam_role" "jenkins_agents" {
  name               = format("%s-jenkins-agents", var.global_name_prefix)
  assume_role_policy = file("${path.module}/iam_policies/assume_role.json")
}

resource "aws_iam_policy" "jenkins_agents" {
  name        = format("%s-jenkins-agents", var.global_name_prefix)
  description = "Allows jenkins agents instances to describe instances for joining consul DC. And deploy to EKS"
  policy      = file("${path.module}/iam_policies/jenkins_agents_policy.json")
}

resource "aws_iam_policy_attachment" "jenkins_agents" {
  name       = format("%s-jenkins-agents", var.global_name_prefix)
  roles      = [aws_iam_role.jenkins_agents.name]
  policy_arn = aws_iam_policy.jenkins_agents.arn
}

resource "aws_iam_instance_profile" "jenkins_agents" {
  name = format("%s-jenkins-agents", var.global_name_prefix)
  role = aws_iam_role.jenkins_agents.name
}
