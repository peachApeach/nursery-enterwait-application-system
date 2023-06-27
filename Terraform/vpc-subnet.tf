#public 서브넷 생성
resource "aws_subnet" "final-project-ecs-vpc-public-subnet-2a" {
  vpc_id            = aws_vpc.final-project-ecs-vpc.id
  cidr_block        = "10.0.0.0/20"
  availability_zone = "ap-northeast-2a"
  tags = {
    Name = "final-project-ecs-public-subnet-2a"
  }
}

resource "aws_subnet" "final-project-ecs-vpc-public-subnet-2c" {
  vpc_id            = aws_vpc.final-project-ecs-vpc.id
  cidr_block        = "10.0.16.0/20"
  availability_zone = "ap-northeast-2c"

  tags = {
    Name = "final-project-ecs-public-subnet-2c"
  }
}
#private 서브넷 생성
resource "aws_subnet" "final-project-ecs-private-subnet-2a" {
  vpc_id            = aws_vpc.final-project-ecs-vpc.id
  cidr_block        = "10.0.32.0/20"
  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "final-project-ecs-private-subnet-2a"
  }
}

resource "aws_subnet" "final-project-ecs-private-subnet-2c" {
  vpc_id            = aws_vpc.final-project-ecs-vpc.id
  cidr_block        = "10.0.48.0/20"
  availability_zone = "ap-northeast-2c"

  tags = {
    Name = "final-project-ecs-private-subnet-2c"
  }
}
#DB 서브넷 그룹 생성
resource "aws_db_subnet_group" "final-project-rds-db-subnet-group" {
  name       = "final-project-rds-db-subnet-group"
  subnet_ids = [aws_subnet.final-project-ecs-private-subnet-2a.id, aws_subnet.final-project-ecs-private-subnet-2c.id]

  tags = {
    Name = "final-project-rds-db-subnet-group"
  }
}