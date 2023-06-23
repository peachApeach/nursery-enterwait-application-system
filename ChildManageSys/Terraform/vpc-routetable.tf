resource "aws_route_table" "final-project-ecs-iac-rtb-public" {
  vpc_id = aws_vpc.final-project-ecs-vpc.id
  tags = {
    Name = "final-project-ecs-iac-rtb-public"
  }
}

resource "aws_route_table" "final-project-ecs-iac-rtb-private1" {
  vpc_id = aws_vpc.final-project-ecs-vpc.id
  tags = {
    Name = "final-project-ecs-iac-rtb-private1"
  }
}

resource "aws_route_table" "final-project-ecs-iac-rtb-private2" {
  vpc_id = aws_vpc.final-project-ecs-vpc.id
  tags = {
    Name = "final-project-ecs-iac-rtb-private2"
  }
}

resource "aws_route_table_association" "final-project-ecs-rtb-con-public1" {
  subnet_id      = aws_subnet.final-project-ecs-vpc-public-subnet-2a.id
  route_table_id = aws_route_table.final-project-ecs-iac-rtb-public.id
}

resource "aws_route_table_association" "final-project-ecs-rtb-con-public2" {
  subnet_id      = aws_subnet.final-project-ecs-vpc-public-subnet-2c.id
  route_table_id = aws_route_table.final-project-ecs-iac-rtb-public.id
}

resource "aws_route_table_association" "final-project-ecs-rtb-con-private1" {
  subnet_id      = aws_subnet.final-project-ecs-private-subnet-2a.id
  route_table_id = aws_route_table.final-project-ecs-iac-rtb-private1.id
}

resource "aws_route_table_association" "final-project-ecs-rtb-con-private2" {
  subnet_id      = aws_subnet.final-project-ecs-private-subnet-2c.id
  route_table_id = aws_route_table.final-project-ecs-iac-rtb-private2.id
}

resource "aws_route" "final-project-ecs-route" {
  route_table_id         = aws_route_table.final-project-ecs-iac-rtb-public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.final-project-ecs-IGW.id
}