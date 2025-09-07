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

variable "control_plane_launch_template" {
  type = object({
    name                                 = string
    disable_api_stop                     = bool
    disable_api_termination              = bool
    instance_type                        = string
    instance_initiated_shutdown_behavior = string
    ebs = object({
      volume_size           = number
      delete_on_termination = bool
    })
  })

  default = {
    name                                 = "nsse-control-plane-lt"
    disable_api_stop                     = true
    disable_api_termination              = true
    instance_type                        = "t3.micro"
    instance_initiated_shutdown_behavior = "terminate"
    ebs = {
      volume_size           = 20
      delete_on_termination = true
    }

  }
}

variable "control_plane_asg" {
  type = object({
    name                      = string
    max_size                  = number
    min_size                  = number
    desired_capacity          = number
    health_check_grace_period = number
    health_check_type         = string
    instance_maintenance_policy = object({
      min_healthy_percentage = number
      max_healthy_percentage = number
    })
    tags = object({
      key                 = string
      value               = string
      propagate_at_launch = bool
    })
  })
  default = {
    name                      = "nsse-control-plane-asg"
    max_size                  = 1
    min_size                  = 1
    desired_capacity          = 1
    health_check_grace_period = 180
    health_check_type         = "EC2"
    instance_maintenance_policy = {
      min_healthy_percentage = 100
      max_healthy_percentage = 110
    }
    tags = {
      key                 = "Name"
      value               = "nsse-control-plane-asg"
      propagate_at_launch = true
    }
  }
}

variable "tags" {
  type = map(string)
  default = {
    Project     = "nsse"
    Managedby   = "Terraform"
    Environment = "production"
  }
}
