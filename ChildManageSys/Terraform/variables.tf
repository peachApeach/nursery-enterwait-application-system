variable "db_username" {
  type        = string
  description = "Username for the database"
}

variable "db_password" {
  type        = string
  description = "Password for the database"
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
  default = 80
}

variable "domain" {
  type = string
  default = "loveliverpool.click"
}

variable "domain-certificate" {
  type = string
  default = "*.loveliverpool.click"
}