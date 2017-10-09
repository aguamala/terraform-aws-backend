output "this_iam_policy_write_access_arn" {
  description = "Terraform state write access IAM policy ARN"
  value       = "${aws_iam_policy.this_write_access.arn}"
}

output "this_iam_policy_write_access_name" {
  description = "Terraform state write access IAM policy name"
  value       = "${aws_iam_policy.this_write_access.name}"
}

