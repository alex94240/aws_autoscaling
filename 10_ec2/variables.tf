variable "allowed_ip_on_app_server" {}
variable "s3_bucket_name" {}
variable "availability_zones" {
  default = ["eu-west-3a", "eu-west-3b"]
}