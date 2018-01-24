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
      "*",
    ]
  }
  
  statement {
    actions = [
      "s3:List*",
      "s3:Get*",
      "s3:PutObject",
    ]

    resources = [
      "arn:aws:s3:::${var.backend_bucket}/${var.tfstate_path}*",
    ]
  }
}

resource "aws_iam_policy" "this_write_access_global" {
  count = "${terraform.workspace == "default" ? 1 : 0}"
  name   = "TerraformBackendWriteAccess_${var.backend_bucket}_${replace(var.tfstate_path, "/", "_")}"
  policy = "${data.aws_iam_policy_document.this_write_access_global.json}"
}

resource "aws_iam_policy_attachment" "backend_access_global_service" {
  count = "${terraform.workspace == "default" ? 1 : 0}"
  name        = "TerraformBackendWriteAccess_${var.backend_bucket}_${replace(var.tfstate_path, "/", "_")}"
  users       = "${var.tfstate_write_users}"
  roles       = "${var.tfstate_write_roles}"
  groups      = "${var.tfstate_write_groups}"
  policy_arn  = "${aws_iam_policy.this_write_access_global.arn}"
}

data "aws_iam_policy_document" "this_write_access_global_iam_policy" {
  count = "${terraform.workspace == "default" ? 1 : 0}"
  
  statement {
    sid = "1"

    actions = [
      "iam:Get*",
      "iam:List*",
    ]

    resources = [
      "${aws_iam_policy.this_write_access_global.arn}",
    ]
  }
}

resource "aws_iam_policy" "this_write_access_global_iam_policy" {
  count = "${terraform.workspace == "default" ? 1 : 0}"
  name   = "TerraformBackendWriteAccessPolicy_${var.backend_bucket}_${replace(var.tfstate_path, "/", "_")}"
  policy = "${data.aws_iam_policy_document.this_write_access_global_iam_policy.json}"
}

resource "aws_iam_policy_attachment" "this_write_access_global_iam_policy" {
  count = "${terraform.workspace == "default" ? 1 : 0}"
  name        = "TerraformBackendWriteAccessPolicy_${var.backend_bucket}_${replace(var.tfstate_path, "/", "_")}"
  users       = "${var.tfstate_write_users}"
  roles       = "${var.tfstate_write_roles}"
  groups      = "${var.tfstate_write_groups}"
  policy_arn  = "${aws_iam_policy.this_write_access_global_iam_policy.arn}"
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
        "env:/${terraform.workspace}/${var.tfstate_path}*",
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
      "arn:aws:s3:::${var.backend_bucket}/env:/${terraform.workspace}/${var.tfstate_path}*",
    ]
  }
}

resource "aws_iam_policy" "this_write_access_workspace" {
  count = "${terraform.workspace != "default" ? 1 : 0}"
  name   = "TerraformBackendWriteAccess_${var.backend_bucket}_${replace(var.tfstate_path, "/", "_")}${terraform.workspace}"
  policy = "${data.aws_iam_policy_document.this_write_access_workspace.json}"
}

resource "aws_iam_policy_attachment" "backend_access_workspace_service" {
  count = "${terraform.workspace != "default" ? 1 : 0}"
  name        = "TerraformBackendWriteAccess_${var.backend_bucket}_${replace(var.tfstate_path, "/", "_")}${terraform.workspace}"
  users       = "${var.tfstate_write_users}"
  roles       = "${var.tfstate_write_roles}"
  groups      = "${var.tfstate_write_groups}"
  policy_arn  = "${aws_iam_policy.this_write_access_workspace.arn}"
}

data "aws_iam_policy_document" "this_write_access_workspace_iam_policy" {
  count = "${terraform.workspace != "default" ? 1 : 0}"
  
  statement {
    sid = "1"

    actions = [
      "iam:Get*",
      "iam:List*",
    ]

    resources = [
      "${aws_iam_policy.this_write_access_workspace.arn}",
    ]
  }
}

resource "aws_iam_policy" "this_write_access_workspace_iam_policy" {
  count = "${terraform.workspace != "default" ? 1 : 0}"
  name   = "TerraformBackendWriteAccessPolicy_${var.backend_bucket}_${replace(var.tfstate_path, "/", "_")}${terraform.workspace}"
  policy = "${data.aws_iam_policy_document.this_write_access_workspace_iam_policy.json}"
}

resource "aws_iam_policy_attachment" "this_write_access_workspace_iam_policy" {
  count = "${terraform.workspace != "default" ? 1 : 0}"
  name        = "TerraformBackendWriteAccessPolicy_${var.backend_bucket}_${replace(var.tfstate_path, "/", "_")}${terraform.workspace}"
  users       = "${var.tfstate_write_users}"
  roles       = "${var.tfstate_write_roles}"
  groups      = "${var.tfstate_write_groups}"
  policy_arn  = "${aws_iam_policy.this_write_access_workspace_iam_policy.arn}"
}