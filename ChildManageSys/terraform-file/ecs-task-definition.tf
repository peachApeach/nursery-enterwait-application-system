#ecr 리포지토리 참조
data "aws_ecr_repository" "reqsys-test" {
  name = "reqsys-test" # 실제 ECR 리포지토리 이름으로 교체해야 합니다.
}

#ecs-task_definition 생성
resource "aws_ecs_task_definition" "final-project-ecs" {
  family                   = "final-project-ecs-task-definition"
  network_mode             = "awsvpc"
  cpu                      = 1024
  memory                   = 3072

  execution_role_arn = aws_iam_role.ecs_execution_role.arn

  requires_compatibilities = ["FARGATE"]
  
  container_definitions = jsonencode([
    {
      name  = "final-project-ecs-task"
      image = "${data.aws_ecr_repository.reqsys-test.repository_url}:latest" #뒤의 latest 태그 부분은 초기 ECS 구축 후 github action의 ECS Deploy시 태그 정상 활성화
      portMappings = [
        {
          "protocol"= "tcp"
          "containerPort": 80,
          "hostPort": 80
        }
      ]
    }
  ])
}
