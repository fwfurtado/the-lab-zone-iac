variable "stage" {
  type        = string
  description = "The stage of the stack"
}

variable "garage_host" {
  type        = string
  description = "Garage admin API endpoint (host:port)"
}

variable "garage_admin_token" {
  type        = string
  description = "Garage admin API token"
  sensitive   = true
}

variable "key_name" {
  type        = string
  description = "Name for the S3 access key"
}

variable "bucket_names" {
  type        = list(string)
  description = "List of bucket global aliases to create"
}
