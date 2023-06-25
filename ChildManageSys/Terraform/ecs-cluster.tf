#ECS-cluster 생성 코드
resource "aws_ecs_cluster" "final-project-ecs-cluster" {
  name = "final-project-cluster"
}

#ECS-service 생성 코드
resource "aws_ecs_service" "final-project-service" {
  name            = "final-project-service"
  cluster         = aws_ecs_cluster.final-project-ecs-cluster.id
  task_definition = aws_ecs_task_definition.final-project-ecs.arn
  desired_count   = 2
  launch_type     = "FARGATE"
  #ECS의 service가 위치하는 네트워크를 설정
  network_configuration {
    subnets          = [aws_subnet.final-project-ecs-vpc-public-subnet-2a.id, aws_subnet.final-project-ecs-vpc-public-subnet-2c.id]
    security_groups  = [aws_security_group.ecs-tasks-sg.id]
    assign_public_ip = true
  }
  #ALB 연결
  load_balancer {
    target_group_arn = aws_lb_target_group.final-project-ecs-service-alb-tg.arn
    container_name   = var.container_name
    container_port   = var.container_port
  }

  depends_on = [aws_lb_listener.https_forward, aws_lb_listener.http_forward, aws_iam_role_policy_attachment.ecs_task_execution_role]
}