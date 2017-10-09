#--------------------------------------------------------------
# S3 backend bucket 
#--------------------------------------------------------------

resource "aws_s3_bucket" "this" {
  bucket = "${var.backend_bucket}"
  acl    = "private"
  region = "${var.backend_bucket_region}"

  versioning {
    enabled = true
  }

  depends_on = ["aws_iam_user_policy_attachment.this"]

  provisioner "local-exec" {
    command = "sleep 15"
  }
}

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
      "s3:List*",
      "s3:Get*",
      "s3:CreateBucket",
      "s3:Put*",
    ]

    resources = [
      "arn:aws:s3:::*",
    ]
  }

}

resource "aws_iam_policy" "this" {
  name   = "TerraformUserCreateBackendBucket_${var.backend_bucket}"
  policy = "${data.aws_iam_policy_document.this.json}"
}

resource "aws_iam_user_policy_attachment" "this" {
  user       = "${var.backend_bucket_user_creator}"
  policy_arn = "${aws_iam_policy.this.arn}"

  provisioner "local-exec" {
    command = "sleep 15"
  }
}

#--------------------------------------------------------------
# S3 readonly_policy for terraform users
#--------------------------------------------------------------

data "aws_iam_policy_document" "this_readonly_access" {
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
      "s3:List*",
      "s3:Get*",
    ]

    resources = [
      "${aws_s3_bucket.this.arn}",
      "${aws_s3_bucket.this.arn}/*",
    ]
  }
}

resource "aws_iam_policy" "this_readonly_access" {
  name   = "TerraformBackendReadOnlyAccess_${var.backend_bucket}"
  policy = "${data.aws_iam_policy_document.this_readonly_access.json}"
}
