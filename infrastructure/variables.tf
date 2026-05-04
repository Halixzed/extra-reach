variable "aws_region" { default = "eu-west-2" }
variable "app_name" { default = "portfolio" }
variable "db_password" { sensitive = true }
variable "app_key" { sensitive = true }