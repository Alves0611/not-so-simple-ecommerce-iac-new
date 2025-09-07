output "launch_template_name" {
  value = aws_launch_template.this.name
}

output "asg_name" {
  value = aws_autoscaling_group.this.name
}
