
# export TF_LOG=TRACE
# export TF_LOG_PATH="./terraform.log"

resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
    comment = "access-identity-promo.${var.domain_name}"
}


resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = aws_s3_bucket.s3_front_opak_bucket.bucket_regional_domain_name
    origin_id   = var.cert_domain_name

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "promo website"
  default_root_object = "index.html"

  logging_config {
    include_cookies = false
    bucket          = aws_s3_bucket.promo-logs.bucket_domain_name
    prefix          = "promo-opak-pl"
  }

  # aliases = ["mysite.example.com", "yoursite.example.com"]

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.cert_domain_name

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  # Cache behavior with precedence 0
#   ordered_cache_behavior {
#     path_pattern     = "/content/immutable/*"
#     allowed_methods  = ["GET", "HEAD", "OPTIONS"]
#     cached_methods   = ["GET", "HEAD", "OPTIONS"]
#     target_origin_id = local.s3_origin_id

#     forwarded_values {
#       query_string = false
#       headers      = ["Origin"]

#       cookies {
#         forward = "none"
#       }
#     }

#     min_ttl                = 0
#     default_ttl            = 86400
#     max_ttl                = 31536000
#     compress               = true
#     viewer_protocol_policy = "redirect-to-https"
#   }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["PL", "FR", "GB", "DE"]
    }
  }

  tags = {
    env = "production"
    project = var.domain_name
  }

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.opak-cert.arn
    ssl_support_method = "sni-only"
  }
}