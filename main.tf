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

    tfstate_write_users  = "${var.tfstate_write_users}"
    tfstate_write_roles  = "${var.tfstate_write_roles}"
    tfstate_write_groups = "${var.tfstate_write_groups}"


    backend_bucket       = "${module.backend_bucket.this_s3_bucket_id}"
    backend_aws_profile  = "${var.backend_aws_profile}"
    backend_aws_region   = "${var.backend_aws_region}"

    tfstate_path = "${var.tfstate_path}"
    workspace    = "${terraform.workspace}"
}




