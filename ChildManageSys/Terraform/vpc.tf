resource "aws_vpc" "final-project-ecs-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "final-project-ecs-vpc"
  }
}