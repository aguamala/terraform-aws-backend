variable "backend_bucket_user_creator" {}

variable "backend_bucket" {
  description = "S3 bucket name to store terraform state file"
}

variable "backend_bucket_region" {
  default     = "us-east-1"
  description = "tf state bucket AWS region"
}
