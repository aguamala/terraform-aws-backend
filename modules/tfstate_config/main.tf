#-----------------------------------------------------------------
# S3 terraform state policy for global service (default workspace)
#-----------------------------------------------------------------
data "aws_iam_policy_document" "this_write_access_global" {
  count = "${terraform.workspace == "default" ? 1 : 0}"
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

resource "aws_iam_policy" "this_write_access_global" {
  count = "${terraform.workspace == "default" ? 1 : 0}"
  name   = "TerraformBackendWriteAccess_${var.backend_bucket}_${replace(var.tfstate_path, "/", "_")}"
  policy = "${data.aws_iam_policy_document.this_write_access_global.json}"
}

#-----------------------------------------------------------------
# S3 terraform state policy for service with many workspaces
#-----------------------------------------------------------------
data "aws_iam_policy_document" "this_write_access_workspace" {
  count = "${terraform.workspace != "default" ? 1 : 0}"
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
        "env:${terraform.workspace}/${var.tfstate_path}*",
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
      "arn:aws:s3:::${var.backend_bucket}/env:${terraform.workspace}/${var.tfstate_path}",
      "arn:aws:s3:::${var.backend_bucket}/env:${terraform.workspace}/${var.tfstate_path}*",
    ]
  }
}

resource "aws_iam_policy" "this_write_access_workspace" {
  count = "${terraform.workspace != "default" ? 1 : 0}"
  name   = "TerraformBackendWriteAccess_${var.backend_bucket}_${replace(var.tfstate_path, "/", "_")}_${terraform.workspace}"
  policy = "${data.aws_iam_policy_document.this_write_access_workspace.json}"
}

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
