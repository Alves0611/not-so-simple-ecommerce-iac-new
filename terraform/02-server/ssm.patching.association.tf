resource "aws_ssm_association" "this" {
  name                = var.debian_association.name
  schedule_expression = var.debian_association.schedule_expression
  association_name    = var.debian_association.association_name
  max_concurrency     = var.debian_association.max_concurrency
  max_errors          = var.debian_association.max_errors

  parameters = {
    Operation    = var.debian_association.parameters.Operation
    RebootOption = var.debian_association.parameters.RebootOption
  }

  targets {
    key    = var.debian_association.targets.key
    values = [var.patch_group]
  }
}
