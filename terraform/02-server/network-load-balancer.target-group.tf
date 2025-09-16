resource "aws_lb_target_group" "nlb_tcp" {
  name        = var.network_load_balancer.default_tg.name
  target_type = "instance"
  port        = var.network_load_balancer.default_tg.port
  protocol    = var.network_load_balancer.default_tg.protocol
  vpc_id      = data.aws_vpc.this.id
}
