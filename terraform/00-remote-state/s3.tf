data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "this" {
  bucket        = "tfstate-${data.aws_caller_identity.current.account_id}"
  force_destroy = true
}
