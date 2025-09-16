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
    key_pair_name                = string
    instance_profile             = string
    instance_role                = string
    ssm_policy_arn               = string
    ssh_security_group           = string
    ssh_source_ip                = string
    control_plane_security_group = string
    worker_security_group        = string
  })
  default = {
    key_pair_name                = "nsse-key-pair"
    instance_profile             = "nsse-instance-profile"
    instance_role                = "nsse-instance-role"
    ssm_policy_arn               = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
    ssh_security_group           = "nsse-allow-ssh"
    ssh_source_ip                = "0.0.0.0/0"
    control_plane_security_group = "nsse-control-plane-sg"
    worker_security_group        = "nsse-worker-sg"
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
    user_data                            = string
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
    user_data                            = "./cli/control-plane-user-data.sh"
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
    instance_tags = object({
      Name = string
    })
    instance_maintenance_policy = object({
      min_healthy_percentage = number
      max_healthy_percentage = number
    })
  })
  default = {
    name                      = "nsse-control-plane-asg"
    max_size                  = 1
    min_size                  = 1
    desired_capacity          = 1
    health_check_grace_period = 180
    health_check_type         = "EC2"
    instance_tags = {
      Name = "nsse-control-plane"
    }
    instance_maintenance_policy = {
      min_healthy_percentage = 100
      max_healthy_percentage = 110
    }
  }
}

variable "worker_launch_template" {
  type = object({
    name                                 = string
    disable_api_stop                     = bool
    disable_api_termination              = bool
    instance_type                        = string
    instance_initiated_shutdown_behavior = string
    user_data                            = string
    ebs = object({
      volume_size           = number
      delete_on_termination = bool
    })
  })

  default = {
    name                                 = "nsse-worker-lt"
    disable_api_stop                     = true
    disable_api_termination              = true
    instance_type                        = "t3.micro"
    instance_initiated_shutdown_behavior = "terminate"
    user_data                            = "./cli/worker-user-data.sh"
    ebs = {
      volume_size           = 20
      delete_on_termination = false
    }
  }
}

variable "worker_asg" {
  type = object({
    name                      = string
    max_size                  = number
    min_size                  = number
    desired_capacity          = number
    health_check_grace_period = number
    health_check_type         = string
    instance_tags = object({
      Name = string
    })
    instance_maintenance_policy = object({
      min_healthy_percentage = number
      max_healthy_percentage = number
    })
  })

  default = {
    name                      = "nsse-worker-asg"
    max_size                  = 1
    min_size                  = 1
    desired_capacity          = 1
    health_check_grace_period = 180
    health_check_type         = "EC2"
    instance_tags = {
      Name = "nsse-worker"
    }
    instance_maintenance_policy = {
      min_healthy_percentage = 100
      max_healthy_percentage = 110
    }
  }
}

variable "debian_patch_baseline" {
  type = object({
    name                                 = string
    description                          = string
    approved_patches_enable_non_security = bool
    operating_system                     = string
    approval_rules = list(object({
      approve_after_days = number
      compliance_level   = string
      patch_filter = object({
        product  = list(string)
        section  = list(string)
        priority = list(string)
      })
    }))
  })

  default = {
    name                                 = "DebianPatchBaseline-prd"
    description                          = "Custom Patch Baseline for Debian Servers"
    approved_patches_enable_non_security = false
    operating_system                     = "DEBIAN"
    approval_rules = [
      {
        approve_after_days = 0
        compliance_level   = "CRITICAL"
        patch_filter = {
          product  = ["Debian12"]
          section  = ["*"]
          priority = ["Required", "Important"]
        }
      },
      {
        approve_after_days = 0
        compliance_level   = "INFORMATIONAL"
        patch_filter = {
          product  = ["Debian12"]
          section  = ["*"]
          priority = ["Standard"]
        }
      }
    ]
  }
}

variable "patch_group" {
  type    = string
  default = "prd"
}

variable "debian_association" {
  type = object({
    name                = string
    schedule_expression = string
    association_name    = string
    max_concurrency     = number
    max_errors          = number
    output_location = object({
      s3_key_prefix = string
    })
    parameters = object({
      Operation    = string
      RebootOption = string
    })
    targets = object({
      key = string
    })
  })

  default = {
    name                = "AWS-RunPatchBaseline"
    schedule_expression = "cron(*/30 * * * ? *)"
    association_name    = "DebianRunPatchBaselineAssociation"
    max_concurrency     = 1
    max_errors          = 0
    output_location = {
      s3_key_prefix = "patching-logs"
    }
    parameters = {
      Operation    = "Install"
      RebootOption = "RebootIfNeeded"
    }
    targets = {
      key = "tag:PatchGroup"
    }
  }
}

variable "logs_bucket" {
  type = object({
    bucket        = string
    force_destroy = bool
  })

  default = {
    bucket        = "nsse-logs"
    force_destroy = true
  }
}

variable "network_load_balancer" {
  type = object({
    name               = string
    internal           = bool
    load_balancer_type = string
    default_tg = object({
      name     = string
      port     = number
      protocol = string
    })
    default_listener = object({
      port     = number
      protocol = string
    })
  })
  default = {
    name               = "nsse-nlb"
    internal           = true
    load_balancer_type = "network"
    default_tg = {
      name     = "nsse-nlb-control-plane-tg"
      port     = 6443
      protocol = "TCP"
    }
    default_listener = {
      port     = 6443
      protocol = "TCP"
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
