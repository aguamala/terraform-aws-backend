#--------------------------------------------------------------
# S3 backend config
#--------------------------------------------------------------
resource "null_resource" "backend" {
  count = "${terraform.workspace == "default" ? 1 : 0}"
  provisioner "local-exec" {
    command = "echo \"${data.template_file.backend.rendered}\" > backend.tf"
  }
}

data "template_file" "backend" {
  count = "${terraform.workspace == "default" ? 1 : 0}"
  template = "${file("${path.module}/templates/backend.tpl")}"

  vars {
    backend_bucket      = "${var.backend_bucket}"
    backend_key         = "${var.tfstate_path}terraform.tfstate"
    backend_aws_region  = "${var.backend_aws_region}"
    backend_aws_profile = "${var.backend_aws_profile}"
  }
}

resource "null_resource" "terraform_remote_state_workspace" {
  count = "${terraform.workspace == "default" && var.terraform_remote_state == "workspace" ? 1 : 0}"
  provisioner "local-exec" {
    command = "echo \"${data.template_file.terraform_remote_state_workspace.rendered}\" >> terraform_remote_state_files_workspace.tf"
  }
}

data "template_file" "terraform_remote_state_workspace" {
  count = "${terraform.workspace == "default" && var.terraform_remote_state == "workspace" ? 1 : 0}"
  template = "${file("${path.module}/templates/terraform_remote_state_workspace.tpl")}"

  vars {
    backend_bucket      = "${var.backend_bucket}"
    tfstate_key         = "${var.tfstate_path}terraform.tfstate"
    tfstate_name        = "${replace(var.tfstate_path, "/", "_")}state"
    backend_aws_region  = "${var.backend_aws_region}"
    backend_aws_profile = "${var.backend_aws_profile}"
  }
}


resource "null_resource" "terraform_remote_state_global" {
  count = "${terraform.workspace == "default" && var.terraform_remote_state == "global" ? 1 : 0}"
  provisioner "local-exec" {
    command = "echo \"${data.template_file.terraform_remote_state_global.rendered}\" >> terraform_remote_state_files_global.tf"
  }
}

data "template_file" "terraform_remote_state_global" {
  count = "${terraform.workspace == "default"  && var.terraform_remote_state == "global" ? 1 : 0}"
  template = "${file("${path.module}/templates/terraform_remote_state_global.tpl")}"

  vars {
    backend_bucket      = "${var.backend_bucket}"
    tfstate_key         = "${var.tfstate_path}terraform.tfstate"
    tfstate_name        = "${replace(var.tfstate_path, "/", "_")}state"
    backend_aws_region  = "${var.backend_aws_region}"
    backend_aws_profile = "${var.backend_aws_profile}"
  }
}
