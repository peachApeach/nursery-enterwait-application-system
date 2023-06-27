#ALB 생성
resource "aws_lb" "final-projcet-ecs-lb" {
  name               = "alb"
  subnets            = [aws_subnet.final-project-ecs-vpc-public-subnet-2a.id, aws_subnet.final-project-ecs-vpc-public-subnet-2c.id]
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb.id]

    #현재 엑세스 로그 부분이 s3 버킷에 엑세스 정책이 제대로 작동하지 않아서 빼놓은 상태로 사용 불가능 코드
#   access_logs {
#     bucket  = aws_s3_bucket.lb-log-storage.id
#     prefix  = "frontend-alb"
#     enabled = true
#   }

  tags = {
    Environment = "final-projcet-ecs-lb"
    Application = var.app_name
  }
}
#ALB의 리스너 생성
#http 리스너 생성
resource "aws_lb_listener" "https_forward" {
  load_balancer_arn = aws_lb.final-projcet-ecs-lb.arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = data.aws_acm_certificate.love-liverpool-certificate.arn
  ssl_policy        = "ELBSecurityPolicy-2016-08"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.final-project-ecs-service-alb-tg.arn
  }
}

#https 리스너 생성
resource "aws_lb_listener" "http_forward" {
  load_balancer_arn = aws_lb.final-projcet-ecs-lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}
#ALB의 타겟 그룹 생성
resource "aws_lb_target_group" "final-project-ecs-service-alb-tg" {
  name        = "final-project-ecs-service-alb-tg"
  port        = 4000
  protocol    = "HTTP"
  vpc_id      = aws_vpc.final-project-ecs-vpc.id
  target_type = "ip"

  health_check {
    enabled             = true
    interval            = 300
    path                = "/"
    timeout             = 60
    matcher             = "200"
    healthy_threshold   = 5
    unhealthy_threshold = 5
  }

  lifecycle {
    create_before_destroy = true
  }
}

# resource "aws_lb_target_group_attachment" "4000-port" {
#   target_group_arn = aws_lb_target_group.final-project-ecs-service-alb-tg.arn
#   port             = 4000
# }