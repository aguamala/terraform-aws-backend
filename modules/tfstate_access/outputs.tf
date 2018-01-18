output "this_iam_policy_write_access_global_arn" {
  description = "Terraform state write access IAM policy ARN"
  value       = "${aws_iam_policy.this_write_access_global.*.arn}"
}

output "this_iam_policy_write_access_global_name" {
  description = "Terraform state write access IAM policy name"
  value       = "${aws_iam_policy.this_write_access_global.*.name}"
}

output "this_iam_policy_write_access_workspace_arn" {
  description = "Terraform state write access IAM policy ARN"
  value       = "${aws_iam_policy.this_write_access_workspace.*.arn}"
}

output "this_iam_policy_write_access_workspace_name" {
  description = "Terraform state write access IAM policy name"
  value       = "${aws_iam_policy.this_write_access_workspace.*.name}"
}
