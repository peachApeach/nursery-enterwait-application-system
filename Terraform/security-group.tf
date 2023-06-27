resource "aws_security_group" "final-project-ecs-public-security-group" {
  vpc_id = aws_vpc.final-project-ecs-vpc.id

  tags = {
    Name = "final-project-ecs-public-security-group"
  }
}

resource "aws_security_group" "final-project-ecs-private-security-group" {
  vpc_id = aws_vpc.final-project-ecs-vpc.id

  tags = {
    Name = "final-project-ecs-private-security-group"
  }
}

resource "aws_security_group_rule" "final-project-ecs-public-security-group-rule1" {
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/32"]
  security_group_id = aws_security_group.final-project-ecs-public-security-group.id
}

resource "aws_security_group_rule" "final-project-ecs-public-security-group-rule2" {
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.final-project-ecs-public-security-group.id
}

resource "aws_security_group_rule" "final-project-ecs-public-security-group-rule3" {
  type = "ingress"
  from_port = 443
  to_port = 443
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.final-project-ecs-public-security-group.id
}

resource "aws_security_group_rule" "final-project-ecs-public-security-group-outboundrule" {
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.final-project-ecs-public-security-group.id
}

/* Security Group for resources that want to access the Database */
resource "aws_security_group" "db_access_sg" {
  vpc_id      = aws_vpc.final-project-ecs-vpc.id
  name        = "db-access-sg"
  description = "Allow access to RDS"
}

resource "aws_security_group" "rds_sg" {
  name = "rds-sg"
  description = "final-project MYSQL DB Security Group"
  vpc_id = aws_vpc.final-project-ecs-vpc.id

  // allows traffic from the SG itself
  ingress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      self = true
  }

  //allow traffic for TCP 5432
  ingress {
      from_port = 3306
      to_port   = 3306
      protocol  = "tcp"
      security_groups = [aws_security_group.db_access_sg.id]
  }

  // outbound internet access
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "lb" {
  vpc_id = aws_vpc.final-project-ecs-vpc.id
  name   = "lb-sg"
  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#ECS task http 보안그룹 인바운드, 아웃바운드 규칙 생성
resource "aws_security_group" "ecs-tasks-sg" {
  vpc_id = aws_vpc.final-project-ecs-vpc.id
  name   = "ecs-tasks-sg"

ingress {
    protocol        = "tcp"
    from_port       = 4000
    to_port         = 4000
    cidr_blocks     = ["0.0.0.0/0"]
    security_groups = [aws_security_group.lb.id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}