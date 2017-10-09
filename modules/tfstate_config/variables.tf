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

variable "tfstate_path" {
  default     = ""
  description = "terraform state file S3 key"
}

variable "tfstate_write_users" {
  default = []
}

variable "tfstate_write_roles" {
  default = []
}

variable "tfstate_write_groups" {
  default = []
}

variable "workspace" {
  description = "terraform workspace"
}