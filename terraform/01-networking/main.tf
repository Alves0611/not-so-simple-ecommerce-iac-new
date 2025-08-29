provider "aws" {
  region = var.region

  assume_role {
    role_arn    = var.aws.role_arn
    external_id = var.aws.external_id
  }

  default_tags {
    tags = var.tags
  }
}
