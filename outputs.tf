output "this_iam_policy_write_access_global_arn" {
  description = "Terraform state write access IAM policy ARN"
  value = "${module.tfstate_config.this_iam_policy_write_access_global_arn}"
}

output "this_iam_policy_write_access_global_name" {
  description = "Terraform state write access IAM policy name"
  value = "${module.tfstate_config.this_iam_policy_write_access_global_name}"
}

output "this_iam_policy_write_access_workspace_arn" {
  description = "Terraform state write access IAM policy ARN"
  value = "${module.tfstate_config.this_iam_policy_write_access_workspace_arn}"
}

output "this_iam_policy_write_access_workspace_name" {
  description = "Terraform state write access IAM policy name"
  value = "${module.tfstate_config.this_iam_policy_write_access_workspace_name}"
}

output "this_s3_bucket_id" {
  description = "The Backend S3 bucket ID"
  value = "${module.backend_bucket.this_s3_bucket_id}"
}

output "this_s3_bucket_arn" {
  description = "The Backend S3 bucket ARN"
  value = "${module.backend_bucket.this_s3_bucket_arn}"
}

output "this_iam_policy_readonly_access_name" {
  description = "The Backend S3 bucket readonly access policy name"
  value = "${module.backend_bucket.this_iam_policy_readonly_access_name}"
}

output "this_iam_policy_readonly_access_arn" {
  description = "The Backend S3 bucket readonly access policy ARN"
  value = "${module.backend_bucket.this_iam_policy_readonly_access_arn}"
}
