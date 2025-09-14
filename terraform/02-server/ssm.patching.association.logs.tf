resource "aws_s3_bucket" "logs" {
  bucket        = "${var.logs_bucket.bucket}-${data.aws_caller_identity.current.account_id}"
  force_destroy = var.logs_bucket.force_destroy

  tags = var.tags
}

resource "aws_s3_bucket_policy" "allow_access_from_instances" {
  bucket = aws_s3_bucket.logs.id
  policy = data.aws_iam_policy_document.allow_access_from_instances.json
}

data "aws_iam_policy_document" "allow_access_from_instances" {
  statement {
    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.this.arn]
    }

    actions = [
      "s3:PutObject",
    ]

    resources = [
      "${aws_s3_bucket.logs.arn}/*",
    ]
  }
}
