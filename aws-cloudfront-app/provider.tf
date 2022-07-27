terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0.0"
    }
    ovh = {
      source  = "ovh/ovh"
      version = ">= 0.18.0"
    }

  }
  required_version = ">= 0.15"
}

provider "aws" {
    profile = "s24"
    region = var.aws_region
}

provider "ovh" {
  endpoint           = "ovh-eu"
  
}
