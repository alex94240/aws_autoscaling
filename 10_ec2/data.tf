data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "name"
    values = ["al2023-ami-*"]
  }
}

data "aws_s3_bucket" "projet_bucket" {
  bucket = var.s3_bucket_name
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
  filter {
    name = "availability-zone"
    values = ["eu-west-3a", "eu-west-3b"]
  }
}

data "aws_vpc" "default" {
  default = true
}