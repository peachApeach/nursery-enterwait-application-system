resource "aws_db_instance" "mysql" {
    identifier = "mysql"
    allocated_storage = 5
    backup_retention_period = 2
    multi_az = false
    engine = "mysql"
    engine_version = "5.7"
    instance_class = "db.t2.micro"
    db_name = "nursery_db"
    username = var.db_username
    password = var.db_password
    port = 3306
    skip_final_snapshot = true
    db_subnet_group_name = aws_db_subnet_group.final-project-rds-db-subnet-group.name
    vpc_security_group_ids = [aws_security_group.final-project-ecs-private-security-group.id, aws_security_group.rds-ecs-sg.id]
}