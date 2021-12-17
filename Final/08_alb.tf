
#VPC-Web ALB
resource "aws_lb" "a4_alb" {
  name = "${var.name}-alb"
  internal = false
  load_balancer_type = var.lb_type[0]
  security_groups = [aws_security_group.alb_sg.id]
  subnets = [aws_subnet.a4_pub[0].id,aws_subnet.a4_pub[1].id]
  tags = {
    "Name" = "${var.name}-alb"
  }
}

#VPC-Web ALB Target Group
resource "aws_lb_target_group" "a4_http_albtg" {
  name = "a4-http-albtg"
  port = var.port_http
  protocol = var.b_protocol_http
  vpc_id = aws_vpc.a4_vpc_web.id
  health_check {
    enabled = true
    healthy_threshold = var.healthy_threshold
    interval = var.health_interval
    matcher = var.health_matcher
    path = var.health_path
    port = var.health_port
    timeout = var.health_timeout
    unhealthy_threshold = var.unhealthy_threshold
  }
}
#VPC-Web ALB listener
resource "aws_lb_listener" "a4_http_alblis" {
  load_balancer_arn = aws_lb.a4_alb.arn
  port = var.port_http
  protocol = var.b_protocol_http

  default_action {
    type = var.lis_default_action
    target_group_arn = aws_lb_target_group.a4_http_albtg.arn
  }
}