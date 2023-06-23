#public 보안 그룹 생성
resource "aws_security_group" "final-project-ecs-public-security-group" {
  vpc_id = aws_vpc.final-project-ecs-vpc.id

  tags = {
    Name = "final-project-ecs-public-security-group"
  }
}
#private 보안 그룹 생성
resource "aws_security_group" "final-project-ecs-private-security-group" {
  vpc_id = aws_vpc.final-project-ecs-vpc.id

  tags = {
    Name = "final-project-ecs-private-security-group"
  }
}
#public 보안그룹 ssh 인바운드 규칙 생성
resource "aws_security_group_rule" "final-project-ecs-public-security-group-rule1" {
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/32"]
  security_group_id = aws_security_group.final-project-ecs-public-security-group.id
}
#public 보안그룹 http 인바운드 규칙 생성
resource "aws_security_group_rule" "final-project-ecs-public-security-group-rule2" {
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.final-project-ecs-public-security-group.id
}
#public 보안그룹 https 인바운드 규칙 생성
resource "aws_security_group_rule" "final-project-ecs-public-security-group-rule3" {
  type = "ingress"
  from_port = 443
  to_port = 443
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.final-project-ecs-public-security-group.id
}
#public 아웃바운드 규칙 생성
resource "aws_security_group_rule" "final-project-ecs-public-security-group-outboundrule" {
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.final-project-ecs-public-security-group.id
}
#private mysql DB 인바운드 규칙 생성
resource "aws_security_group_rule" "final-project-ecs-private-security-group-rule1" {
  type = "ingress"
  from_port = 3306
  to_port = 3306
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.final-project-ecs-private-security-group.id
}
#private 아웃바운드 규칙 생성
resource "aws_security_group_rule" "final-project-ecs-private-security-group-outboundrule" {
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.final-project-ecs-private-security-group.id
}
#ECS task http 보안그룹 인바운드, 아웃바운드 규칙 생성
resource "aws_security_group" "ecs-tasks-sg" {
  vpc_id = aws_vpc.final-project-ecs-vpc.id
  name   = "ecs-tasks-sg"

  ingress {
    protocol        = "tcp"
    from_port       = 80
    to_port         = 80
    cidr_blocks     = ["0.0.0.0/0"]
    security_groups = [aws_security_group.final-project-ecs-public-security-group.id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}