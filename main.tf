#--------------------------------------------------------------
#  backend bucket
#--------------------------------------------------------------
module "backend_bucket" {
    source = "./modules/backend_bucket"
    backend_bucket_user_creator = "${var.backend_bucket_user_creator}"
    backend_bucket              = "${var.backend_bucket}"
    backend_bucket_region       = "${var.backend_bucket_region}"
}

#--------------------------------------------------------------
#  backend access
#--------------------------------------------------------------
module "tfstate_config" {
    source = "./modules/tfstate_config"

    backend_bucket       = "${module.backend_bucket.this_s3_bucket_id}"
    backend_aws_profile  = "${var.backend_aws_profile}"
    backend_aws_region   = "${var.backend_aws_region}"

    tfstate_path = "${var.tfstate_path}"
}

resource "aws_iam_policy_attachment" "backend_access_global_service" {
  count = "${terraform.workspace == "default" ? 1 : 0}"
  name        = "TerraformBackendWriteAccess_${module.backend_bucket.this_s3_bucket_id}_${replace(var.tfstate_path, "/", "_")}"
  users       = "${var.tfstate_write_users}"
  roles       = "${var.tfstate_write_roles}"
  groups      = "${var.tfstate_write_groups}"
  policy_arn  = "${module.tfstate_config.this_iam_policy_write_access_global_arn}"
}

resource "aws_iam_policy_attachment" "backend_access_workspace_service" {
  count = "${terraform.workspace != "default" ? 1 : 0}"
  name        = "TerraformBackendWriteAccess_${module.backend_bucket.this_s3_bucket_id}_${replace(var.tfstate_path, "/", "_")}_${terraform.workspace}"
  users       = "${var.tfstate_write_users}"
  roles       = "${var.tfstate_write_roles}"
  groups      = "${var.tfstate_write_groups}"
  policy_arn  = "${module.tfstate_config.this_iam_policy_write_access_workspace_arn}"
}


