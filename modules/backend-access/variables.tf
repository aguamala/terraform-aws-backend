variable "backend_aws_profile" {
  default     = "default"
  description = "Terraform AWS profile"
}

variable "backend_aws_region" {
  default     = "us-east-1"
  description = "tf state bucket AWS region"
}

variable "backend_bucket" {
  default     = "terraform-state-versioning"
  description = "S3 bucket name to store terraform state file"
}

variable "backend_path" {
  default     = ""
  description = "terraform state file S3 key"
}

variable "backend_write_users" {
  type    = "list"
  default = []
}

variable "backend_write_roles" {
  type    = "list"
  default = []
}

variable "backend_write_groups" {
  type    = "list"
  default = []
}
