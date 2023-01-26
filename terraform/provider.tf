terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.3.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.2.1"
    }
  }
   backend "s3" {
    bucket = "shoval-tf-state-443"
    key    = "terraform.tfstate"
    region = "eu-west-3"
  }
}
# Configure the AWS Provider
provider "aws" {
  region = var.region
}

provider "local" {
  # Configuration options
}

provider "null" {
  # Configuration options
}