resource "aws_lb_target_group" "my-target-group" {
  health_check {
    interval            = 10
    path                = "/"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }

  name        = "my-test-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      =  aws_vpc.terra_vpc.id
}

resource "aws_lb_target_group_attachment" "my-alb-target-group-attachment1" {
  target_group_arn = aws_lb_target_group.my-target-group.arn
  target_id        = element(aws_instance.Tinstance.*.id, 1)
  port             = 80
}

resource "aws_lb_target_group_attachment" "my-alb-target-group-attachment2" {
  target_group_arn = aws_lb_target_group.my-target-group.arn
  target_id        = element(aws_instance.Tinstance.*.id, 2)
  port             = 80
}

resource "aws_lb" "my-aws-alb" {
  name     = "my-test-alb"
  internal = false
  security_groups = [aws_security_group.servicesg.id ]
   subnets = aws_subnet.public.*.id
    
  
    
  tags = {
    Name = "my-test-alb"
  }

  ip_address_type    = "ipv4"
  load_balancer_type = "application"
}

resource "aws_lb_listener" "my-test-alb-listner" {
  load_balancer_arn = aws_lb.my-aws-alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my-target-group.arn
  }
}


