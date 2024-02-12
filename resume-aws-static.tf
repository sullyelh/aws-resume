provider "aws" {
  region = "us-east-1"
}

#creates the bucket, names it sullyelh.com, tf var is sullyelhcom
resource "aws_s3_bucket" "sullyelhcom" {
  bucket = "sullyelh.com"

  tags = {
    Name = "Resume"
  }
}

#configures the bucket to use index.html/error.html for hosting
resource "aws_s3_bucket_website_configuration" "sullyelhcom" {
  bucket = aws_s3_bucket.sullyelhcom.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

#Loads the index and error files from my local machine
resource "aws_s3_object" "provision_source_files" {
  bucket = aws_s3_bucket.sullyelhcom.id

  for_each = fileset("static-files/", "**/*.*")

  key = each.value
  source = "aws-resume/${each.value}"
  content_type = each.value
}

#essentially unchecks the block-public-access settings on s3 bucket
resource "aws_s3_bucket_public_access_block" "sullyelhcom" {
  bucket = aws_s3_bucket.sullyelhcom.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

#read policy for public
resource "aws_s3_bucket_policy" "sullyelhcom" {
  bucket = aws_s3_bucket.sullyelhcom.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "PublicReadGetObject",
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource  = "${aws_s3_bucket.sullyelhcom.arn}/*"
      }
    ]
  })
}