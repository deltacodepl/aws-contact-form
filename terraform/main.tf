resource "aws_s3_bucket" "js-contact-form" {
    bucket = var.bucket_name
    tags = {
      "category" = "web"
      "env" = "dev"
    }
}

resource "aws_s3_bucket_acl" "js-contact-form-acl" {
    bucket = aws_s3_bucket.js-contact-form.id
    acl = "public-read"
}

resource "aws_s3_bucket_versioning" "js-contact-form-ver" {
    bucket = aws_s3_bucket.js-contact-form.id
    versioning_configuration {
      status = "Suspended"
    }
}

# resource "aws_s3_object" "formjs" {
#     bucket = aws_s3_bucket.js-contact-form.id
#     key = "form.js"
#     source = "../form.js"
#     etag = filemd5("../form.js")
#     acl = "public-read"
# }
   


