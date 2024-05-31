resource "aws_lb_target_group" "servers" {
  name     = "alb-projet-tg"
  port     = 1080
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id
  health_check {
    path = "/mockserver/dashboard"
    port = 1080
  }
}

resource "aws_lb" "alb" {
    name               = "alb-projet"
    internal           = false
    load_balancer_type = "application"
    security_groups    = [aws_security_group.app_server_sg.id]
    subnets            = data.aws_subnets.default.ids
}

resource "aws_lb_target_group_attachment" "tg_attachment" {
    for_each         = aws_instance.app_server
    target_group_arn = aws_lb_target_group.servers.arn
    target_id        = each.value.id
    port             = 1080
}

resource "aws_lb_listener" "server_listener" {
 load_balancer_arn = aws_lb.alb.arn
 port              = "80"
 protocol          = "HTTP"

 default_action {
   type             = "forward"
   target_group_arn = aws_lb_target_group.servers.arn
 }
}

resource "aws_security_group" "lb_sg" {
  name        = "alb_sg"
  description = "Allow specific access to ec2 from lb"

  tags = {
    Name = "projet"
  }
}
resource "aws_vpc_security_group_ingress_rule" "allow_lb" {
  security_group_id = aws_security_group.lb_sg.id
  cidr_ipv4   = var.allowed_ip_on_app_server
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80
}
