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

variable "ec2_resources" {
  type = object({
    key_pair_name      = string
    instance_profile   = string
    instance_role      = string
    ssm_policy_arn     = string
    ssh_security_group = string
    ssh_source_ip      = string
  })
  default = {
    key_pair_name      = "nsse-key-pair"
    instance_profile   = "nsse-instance-profile"
    instance_role      = "nsse-instance-role"
    ssm_policy_arn     = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
    ssh_security_group = "nsse-allow-ssh"
    ssh_source_ip      = "0.0.0.0/0"
  }
}

variable "vpc_resources" {
  type = object({
    vpc = string
  })
  default = {
    vpc = "nsse-vpc"
  }
}

variable "tags" {
  type = map(string)
  default = {
    Project   = "nsse"
    Managedby = "Terraform"
  }
}
