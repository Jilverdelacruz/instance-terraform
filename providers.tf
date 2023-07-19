terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region     = "us-east-1"
  access_key = "AKIAZS4KS7CMUVU2VTHW"
  secret_key = "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"
  default_tags {
    tags = var.tags_Virginia
  }
}

