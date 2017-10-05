#--------------------------------------------------------------
# Terraform backend file modifier groups
#--------------------------------------------------------------

resource "aws_iam_policy_attachment" "write" {
  name       = "TerraformBackendAccess${replace(var.backend_path, "/", "_")}Write"
  users      = "${var.backend_write_users}"
  roles      = "${var.backend_write_roles}"
  groups     = "${var.backend_write_groups}"
  policy_arn = "${aws_iam_policy.remote_state_config.arn}"
}


