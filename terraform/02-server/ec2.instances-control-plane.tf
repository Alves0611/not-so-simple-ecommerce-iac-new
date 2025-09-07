module "ec2_control_plane" {
  source = "./modules/ec2"

  key_name               = aws_key_pair.this.key_name
  instance_profile_name  = aws_iam_instance_profile.this.name
  vpc_zone_identifier    = data.aws_subnets.private.ids
  image_id               = data.aws_ami.this.id
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  launch_template = {
    name                                 = var.control_plane_launch_template.name
    disable_api_stop                     = var.control_plane_launch_template.disable_api_stop
    disable_api_termination              = var.control_plane_launch_template.disable_api_termination
    instance_type                        = var.control_plane_launch_template.instance_type
    instance_initiated_shutdown_behavior = var.control_plane_launch_template.instance_initiated_shutdown_behavior
    ebs = {
      volume_size           = var.control_plane_launch_template.ebs.volume_size
      delete_on_termination = var.control_plane_launch_template.ebs.delete_on_termination
    }
  }

  auto_scaling_group = {
    name                      = var.control_plane_asg.name
    max_size                  = var.control_plane_asg.max_size
    min_size                  = var.control_plane_asg.min_size
    desired_capacity          = var.control_plane_asg.desired_capacity
    health_check_type         = var.control_plane_asg.health_check_type
    health_check_grace_period = var.control_plane_asg.health_check_grace_period
    vpc_zone_identifier       = data.aws_subnets.private.ids
    instance_maintenance_policy = {
      min_healthy_percentage = var.control_plane_asg.instance_maintenance_policy.min_healthy_percentage
      max_healthy_percentage = var.control_plane_asg.instance_maintenance_policy.max_healthy_percentage
    }
  }

  tags = var.tags
}
