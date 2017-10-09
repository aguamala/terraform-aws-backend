output "this_s3_bucket_id" {
  description = "The Backend S3 bucket ID"
  value       = "${aws_s3_bucket.this.id}"
}

output "this_s3_bucket_arn" {
  description = "The Backend S3 bucket ARN"
  value       = "${aws_s3_bucket.this.arn}"
}

output "this_iam_policy_readonly_access_name" {
  description = "The Backend S3 bucket readonly access policy name"
  value       = "${aws_iam_policy.this_readonly_access.name}"
}

output "this_iam_policy_readonly_access_arn" {
  description = "The Backend S3 bucket readonly access policy ARN"
  value       = "${aws_iam_policy.this_readonly_access.arn}"
}

