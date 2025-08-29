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
    vpc                     = string
    vpc_cidr_block          = string
    internet_gateway        = string
    public_route_table_name = string

    public_subnets = list(object({
      name                    = string
      cidr_block              = string
      availability_zone       = string
      map_public_ip_on_launch = bool
    }))
  })

  default = {
    vpc                     = "nsse-vpc"
    vpc_cidr_block          = "10.0.0.0/24"
    internet_gateway        = "igw"
    public_route_table_name = "public-rt"

    public_subnets = [
      {
        name                    = "public-1a"
        availability_zone       = "us-east-1a"
        cidr_block              = "10.0.0.0/27"
        map_public_ip_on_launch = true
      },
      {
        name                    = "public-1b"
        availability_zone       = "us-east-1b"
        cidr_block              = "10.0.0.64/27"
        map_public_ip_on_launch = true
      }
    ]
  }
}

variable "tags" {
  type = map(string)
  default = {
    Project   = "nsse"
    Managedby = "Terraform"
  }
}
