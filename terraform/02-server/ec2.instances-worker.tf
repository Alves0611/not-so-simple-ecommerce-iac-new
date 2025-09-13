
module "ec2_worker" {
  source = "./modules/ec2"

  instance_profile_name = aws_iam_instance_profile.this.name

  launch_template = {
    name                                 = var.worker_launch_template.name
    disable_api_stop                     = var.worker_launch_template.disable_api_stop
    disable_api_termination              = var.worker_launch_template.disable_api_termination
    instance_type                        = var.worker_launch_template.instance_type
    instance_initiated_shutdown_behavior = var.worker_launch_template.instance_initiated_shutdown_behavior
    key_name                             = aws_key_pair.this.key_name
    image_id                             = data.aws_ami.this.id
    vpc_security_group_ids               = [aws_security_group.allow_ssh.id]
    user_data                            = filebase64(var.worker_launch_template.user_data)
    ebs = {
      volume_size           = var.worker_launch_template.ebs.volume_size
      delete_on_termination = var.worker_launch_template.ebs.delete_on_termination
    }
  }

  auto_scaling_group = {
    name                      = var.worker_asg.name
    max_size                  = var.worker_asg.max_size
    min_size                  = var.worker_asg.min_size
    desired_capacity          = var.worker_asg.desired_capacity
    health_check_type         = var.worker_asg.health_check_type
    health_check_grace_period = var.worker_asg.health_check_grace_period
    vpc_zone_identifier       = data.aws_subnets.private.ids
    target_group_arns         = []
    instance_maintenance_policy = {
      min_healthy_percentage = var.worker_asg.instance_maintenance_policy.min_healthy_percentage
      max_healthy_percentage = var.worker_asg.instance_maintenance_policy.max_healthy_percentage
    }
  }

  tags = var.tags
}
