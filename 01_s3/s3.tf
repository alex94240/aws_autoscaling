resource "aws_s3_bucket" "private_projet_bucket" {
  bucket = var.s3_bucket_name

  tags = {
    Name        = "projet"
  }
}