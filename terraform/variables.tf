variable "aws_region" {
    type = string
    default = "eu-central-1"
}

variable "bucket_name" {
    type = string
    default = "js-contact-form"
}

variable "domain_name" {
  type = string
}

variable "cert_domain_name" {
  type = string  
}