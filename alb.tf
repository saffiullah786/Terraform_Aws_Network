resource "aws_lb" "main-alb" {
  name                       = "main-alb"
  internal                   = false
  security_groups            = [aws_security_group.public-sg.id]
  subnets                    = [aws_subnet.public-subnet-1.id, aws_subnet.public-subnet-2.id]
  enable_deletion_protection = false
}
resource "aws_lb_listener" "main-listener" {
  load_balancer_arn = aws_lb.main-alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main-tg.arn
  }
}

#Need Ssl certificate which is free but u need a domain name which i dotn have so alb dont allow 443
# resource "aws_lb_listener" "https" {
#   load_balancer_arn = aws_lb.web-alb.arn
#   port              = 443
#   protocol          = "HTTPS"
#   ssl_policy        = "ELBSecurityPolicy-2016-08" # Default AWS security policy
#   certificate_arn   = var.ssl_certificate_arn     # Requires an ACM Certificate ARN variable

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.web-tg.arn # Forwards as HTTP Port 80 to your private app!
#   }
# }

#also alb translate 443 to 80 automatically no need to define rules in sg for 443



resource "aws_lb_target_group" "main-tg" {
  name        = "main-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main-vpc.id
  target_type = "instance"
  health_check {
    path                = "/" # The URL path AWS checks to see if your app is alive or no
    port                = "80"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}
// we dont need this attachment below cuz its for public we dont wana sedn req to public cuz traffic should send req to private to see app which is managed by autoscaling so dont need this at all
# resource "aws_lb_target_group_attachment" "main-tg-attachment" {
#   target_group_arn = aws_lb_target_group.main-tg.arn
#   target_id        = [aws_instance.public-ec2-1.id, aws_instance.public-ec2-4.id]
#   port             = 80
# }