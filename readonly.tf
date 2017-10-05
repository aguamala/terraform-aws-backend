#--------------------------------------------------------------
# S3 readonly_policy for terraform users
#--------------------------------------------------------------

data "aws_iam_policy_document" "readonly_policy" {
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

resource "aws_iam_policy" "readonly_policy" {
  name   = "TerraformBackendS3BucketReadOnlyAccess_${var.terraform_backend_s3_bucket}"
  policy = "${data.aws_iam_policy_document.readonly_policy.json}"
}
