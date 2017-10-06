#--------------------------------------------------------------
# S3 terraform state policy
#--------------------------------------------------------------
data "aws_iam_policy_document" "this" {
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
        "${var.backend_path}*",
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
      "arn:aws:s3:::${var.backend_bucket}/${var.backend_path}",
      "arn:aws:s3:::${var.backend_bucket}/${var.backend_path}*",
    ]
  }
}

resource "aws_iam_policy" "this" {
  name   = "${var.backend_bucket}_${replace(var.backend_path, "/", "_")}write_remote_state_s3_config"
  policy = "${data.aws_iam_policy_document.this.json}"
}

#--------------------------------------------------------------
# S3 backend config
#--------------------------------------------------------------
resource "null_resource" "this" {
  provisioner "local-exec" {
    command = "echo \"${data.template_file.this.rendered}\" > backend.tf"
  }
}

data "template_file" "this" {
  template = "${file("${path.module}/templates/backend.tpl")}"

  vars {
    backend_bucket      = "${var.backend_bucket}"
    backend_key         = "${var.backend_path}terraform.backend"
    backend_aws_region  = "${var.backend_aws_region}"
    backend_aws_profile = "${var.backend_aws_profile}"
  }
}

resource "null_resource" "create_data_state_file" {
  provisioner "local-exec" {
    command = "echo \"${data.template_file.data_state_file.rendered}\" >> data_backend_files.tf"
  }
}

data "template_file" "data_state_file" {
  template = "${file("${path.module}/templates/data_backend_files.tpl")}"

  vars {
    backend_bucket      = "${var.backend_bucket}"
    backend_key         = "${var.backend_path}terraform.backend"
    backend_name        = "${replace(var.backend_path, "/", "_")}file"
    backend_aws_region  = "${var.backend_aws_region}"
    backend_aws_profile = "${var.backend_aws_profile}"
  }
}


#--------------------------------------------------------------
# Terraform backend file modifier groups
#--------------------------------------------------------------

resource "aws_iam_policy_attachment" "write" {
  name       = "TerraformBackendAccess${replace(var.backend_path, "/", "_")}Write"
  users      = "${var.backend_write_users}"
  roles      = "${var.backend_write_roles}"
  groups     = "${var.backend_write_groups}"
  policy_arn = "${aws_iam_policy.this.arn}"
}

