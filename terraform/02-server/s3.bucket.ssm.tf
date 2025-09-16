resource "aws_s3_bucket" "ansible_ssm" {
  bucket = "nsse-ansible-ssm-${data.aws_caller_identity.current.account_id}"

  tags = var.tags
}
