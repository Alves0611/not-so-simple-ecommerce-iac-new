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
    role_arn    = "arn:aws:iam::444065722670:role/terraform-role"
    external_id = "679e2de7-7db8-4114-af04-6620fdae82f9"
  }
}


variable "vpc_resources" {
  type = object({
    vpc              = string,
    vpc_cidr_block   = string,
    internet_gateway = string,
  })

  default = {
    vpc              = "nsse-vpc",
    vpc_cidr_block   = "10.0.0.0/24",
    internet_gateway = "igw"
  }
}

variable "tags" {
  type = map(string)
  default = {
    Project   = "nsse"
    Managedby = "Terraform"
  }
}
