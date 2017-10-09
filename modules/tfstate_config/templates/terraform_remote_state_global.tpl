
data "\"terraform_remote_state\"" "\"${tfstate_name}\"" {
    backend = "\"s3\""
    config {
        bucket = "\"${backend_bucket}\""
        region = "\"${backend_aws_region}\""
        key = "\"${tfstate_key}\""
        profile = "\"${backend_aws_profile}\""
    }
}
