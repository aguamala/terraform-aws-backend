#--------------------------------------------------------------
# S3 terraform state policy
#--------------------------------------------------------------
data "aws_iam_policy_document" "this_write_access" {
  statement {
    sid = "1"

    actions = [
      "s3:ListAllMyBuckets",
      "s3:GetBucketLocation",
    ]

    resources = [
      "arn:aws:s3:::*",
    ]
  }

  statement {
    actions = [
      "s3:ListBucket",
    ]

    resources = [
      "arn:aws:s3:::${var.backend_bucket}",
    ]

    condition {
      test     = "StringLike"
      variable = "s3:prefix"

      values = [
        "",
        "${var.tfstate_path}*",
      ]
    }
  }

  statement {
    actions = [
      "s3:List*",
      "s3:Get*",
      "s3:PutObject",
    ]

    resources = [
      "arn:aws:s3:::${var.backend_bucket}/${var.tfstate_path}",
      "arn:aws:s3:::${var.backend_bucket}/${var.tfstate_path}*",
    ]
  }
}

resource "aws_iam_policy" "this_write_access" {
  name   = "TerraformBackendWriteAccess_${var.backend_bucket}_${replace(var.tfstate_path, "/", "_")}"
  policy = "${data.aws_iam_policy_document.this_write_access.json}"
}

resource "aws_iam_policy_attachment" "this_write_access" {
  name        = "TerraformBackendWriteAccess_${var.backend_bucket}_${replace(var.tfstate_path, "/", "_")}"
  users       = "${var.tfstate_write_users}"
  roles       = "${var.tfstate_write_roles}"
  groups      = "${var.tfstate_write_groups}"
  policy_arn  = "${aws_iam_policy.this_write_access.arn}"
}

#--------------------------------------------------------------
# S3 backend config
#--------------------------------------------------------------
resource "null_resource" "backend" {
  provisioner "local-exec" {
    command = "echo \"${data.template_file.backend.rendered}\" > backend.tf"
  }
}

data "template_file" "backend" {
  template = "${file("${path.module}/templates/backend.tpl")}"

  vars {
    backend_bucket      = "${var.backend_bucket}"
    backend_key         = "${var.tfstate_path}terraform.tfstate"
    backend_aws_region  = "${var.backend_aws_region}"
    backend_aws_profile = "${var.backend_aws_profile}"
  }
}

resource "null_resource" "terraform_remote_state_workspace" {
  count = "${terraform.workspace != "default" ? 1 : 0}"
  provisioner "local-exec" {
    command = "echo \"${data.template_file.terraform_remote_state_workspace.rendered}\" >> terraform_remote_state_files_workspace.tf"
  }
}

data "template_file" "terraform_remote_state_workspace" {
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
  count = "${terraform.workspace == "default" ? 1 : 0}"
  provisioner "local-exec" {
    command = "echo \"${data.template_file.terraform_remote_state_global.rendered}\" >> terraform_remote_state_files_global.tf"
  }
}

data "template_file" "terraform_remote_state_global" {
  template = "${file("${path.module}/templates/terraform_remote_state_global.tpl")}"

  vars {
    backend_bucket      = "${var.backend_bucket}"
    tfstate_key         = "${var.tfstate_path}terraform.tfstate"
    tfstate_name        = "${replace(var.tfstate_path, "/", "_")}state"
    backend_aws_region  = "${var.backend_aws_region}"
    backend_aws_profile = "${var.backend_aws_profile}"
  }
}
