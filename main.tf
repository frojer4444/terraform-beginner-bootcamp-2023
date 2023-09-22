terraform {
  cloud {
    organization = "Icario"

    workspaces {
      name = "terra-house-1"
    }
  }
}


provider "aws" {
  # Configuration options
}

provider "random" {
  # Configuration options
}

resource "random_string" "bucket_name" {
  lower = true
  upper = false
  length = 32
  special = false
}

resource "aws_s3_bucket" "example" {
  bucket = random_string.bucket_name.result
  }


output "random_bucket_result" {
    value = random_string.bucket_name.result
}


