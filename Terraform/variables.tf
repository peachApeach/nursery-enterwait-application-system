variable "db_username" {
  type        = string
  description = "Username for the database"
}

variable "db_password" {
  type        = string
  description = "Password for the database"
}

variable "db_database" {
  type        = string
  description = "Name for the database"
  default = "nursery"
}

variable "app_name" {
  type = string
  default = "final-project-service"
}

variable "container_name" {
  type = string
  default = "final-project-ecs-task"
}

variable "container_port" {
  type    = number
  default = 4000
}

variable "domain" {
  type = string
  default = "loveliverpool.click"
}

variable "domain-certificate" {
  type = string
  default = "*.loveliverpool.click"
}

# database connection variables
variable "HOSTNAME" {
  description = "HOSTNAME"
  type = map
  default = {}
}

variable "DATABASE" {
  description = "DATABASE"
  type = map
  default = {}
}

variable "USERNAME" {
  description = "USERNAME"
  type = map
  default = {}
}

variable "PASSWORD" {
  description = "PASSWORD"
  type = map
  default = {}
}

# AWS Access variables
variable "AWS_ACCESS_KEY_ID" {
  description = "AWS_ACCESS_KEY_ID"
  type = map
  default = {}
}

variable "AWS_SECRET_ACCESS_KEY" {
  description = "AWS_SECRET_ACCESS_KEY"
  type = map
  default = {}
}

variable "REGION" {
  description = "REGION"
  type = map
  default = {}
}