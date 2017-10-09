
data "\"terraform_remote_state\"" "\"${tfstate_name}\"" {

    environment = "\"\$\{terraform.workspace\}\""

    backend = "\"s3\""
    config {
        bucket = "\"${backend_bucket}\""
        region = "\"${backend_aws_region}\""
        key = "\"${tfstate_key}\""
        profile = "\"${backend_aws_profile}\""
    }
}
