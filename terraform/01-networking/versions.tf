terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket         = "tfstate-444065722670"
    key            = "nsse/networking/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "state-locking-444065722670"
  }
}
