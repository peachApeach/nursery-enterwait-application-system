#### rds ####
resource "aws_db_instance" "nursery" {
    identifier = "nursery"
    allocated_storage = 5
    backup_retention_period = 2
    multi_az = false
    engine = "mysql"
    engine_version = "5.7"
    instance_class = "db.t2.micro"
    db_name = var.db_database
    username = var.db_username
    password = var.db_password
    port = 3306
    skip_final_snapshot = true
    db_subnet_group_name = aws_db_subnet_group.final-project-rds-db-subnet-group.name
    vpc_security_group_ids = [aws_security_group.rds_sg.id]
}
