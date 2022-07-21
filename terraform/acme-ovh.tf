resource "aws_acm_certificate" "opak-cert" {
  domain_name       = var.domain_name
  subject_alternative_names = [ var.cert_domain_name]
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}

resource "ovh_domain_zone_record" "ovh_acm_record" {
    for_each = {
      for dvo in aws_acm_certificate.opak-cert.domain_validation_options : dvo.domain_name => {
        # name = trim(dvo.resource_record_name, ".")
        name = dvo.resource_record_name
        record = dvo.resource_record_value
        type = dvo.resource_record_type
      }
    }

    zone      = var.domain_name
    # name of the record
    subdomain = each.value.name
    fieldtype = each.value.type
    ttl       = "60"
    # value of the record
    target    = each.value.record
}

resource "aws_acm_certificate_validation" "ovh_acm_validation" {
    certificate_arn = aws_acm_certificate.opak-cert.arn
    validation_record_fqdns = [ for record in ovh_domain_zone_record.ovh_acm_record : "${record.subdomain}"]
}
