variable "backend_bucket" {
  default     = ""
  description = "S3 bucket name to store terraform state file"
}

variable "tfstate_path" {
  default     = ""
  description = "terraform state file S3 key"
}

variable "tfstate_write_users" {
  default     = []
  description = "terraform state file write users access"
}

variable "tfstate_write_roles" {
  default     = []
  description = "terraform state file write roles access"
}

variable "tfstate_write_groups" {
  default     = []
  description = "terraform state file write groups access"
}