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
#  tfstate config
#--------------------------------------------------------------
module "tfstate_config" {
    source = "./modules/tfstate_config"

    backend_bucket       = "${module.backend_bucket.this_s3_bucket_id}"
    backend_aws_profile  = "${var.backend_aws_profile}"
    backend_aws_region   = "${var.backend_aws_region}"

    tfstate_path = "${var.tfstate_path}"
}

#--------------------------------------------------------------
#  tfstate access
#--------------------------------------------------------------
module "tfstate_access" {
    source = "./modules/tfstate_access"

    backend_bucket       = "${module.backend_bucket.this_s3_bucket_id}"
    tfstate_path         = "${var.tfstate_path}"
    tfstate_write_users  = "${var.tfstate_write_users}"
    tfstate_write_roles  = "${var.tfstate_write_roles}"
    tfstate_write_groups = "${var.tfstate_write_groups}"
}
