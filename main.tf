#--------------------------------------------------------------
# Create S3 bucket terraform state policy
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
    sid = "2"
    actions = [
      "s3:CreateBucket",
    ]

    resources = [
      "arn:aws:s3:::*",
    ]
  }

}

resource "aws_iam_policy" "this" {
  name   = "TerraformUserCreateBackendBucket_${var.terraform_backend_s3_bucket}"
  policy = "${data.aws_iam_policy_document.this.json}"
}

resource "aws_iam_user_policy_attachment" "this" {
  user       = "${var.aws_user_bucket_creator}"
  policy_arn = "${aws_iam_policy.this.arn}"

  provisioner "local-exec" {
    command = "sleep 15"
  }
}

#--------------------------------------------------------------
# S3 backend bucket
#--------------------------------------------------------------

resource "aws_s3_bucket" "this" {
  bucket = "${var.terraform_backend_s3_bucket}"
  acl    = "private"
  region = "${var.terraform_backend_s3_bucket_aws_region}"

  versioning {
    enabled = true
  }

  depends_on = ["aws_iam_user_policy_attachment.this"]

  provisioner "local-exec" {
    command = "sleep 15"
  }
}

#--------------------------------------------------------------
# config backend access
#--------------------------------------------------------------

