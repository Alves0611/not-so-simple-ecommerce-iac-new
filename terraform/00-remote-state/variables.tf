variable "region" {
  type    = string
  default = "us-east-1"
}

variable "aws" {
  type = object({
    role_arn    = string
    external_id = string
  })

  default = {
    role_arn    = "arn:aws:iam::891377404175:role/terraform-role"
    external_id = "679e2de7-7db8-4114-af04-6620fdae82f9"
  }
}
