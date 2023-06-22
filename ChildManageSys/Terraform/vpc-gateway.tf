resource "aws_internet_gateway" "final-project-ecs-IGW" {
  vpc_id = aws_vpc.final-project-ecs-vpc.id

  tags = {
    Name = "final-project-ecs-internet-gateway"
  }
}