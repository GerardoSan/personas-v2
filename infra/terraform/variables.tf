variable "aws_region" {
  type    = string
  default = "us-east-2"
}

variable "project" {
  type    = string
  default = "prestamype-app"
}

variable "environment" {
  type    = string
  default = "dev"
}


variable "artifacts_bucket" {
  type = string
  description = "SUBIR LAMBDA ZIP A S3"
  default = "lambda-persona"
}


variable "db_instance_class" {
  type    = string
  default = "db.t3.micro"
}

variable "db_allocated_storage" {
  type    = number
  default = 20
}

variable "db_engine" {
  type    = string
  default = "mysql"
}

variable "db_engine_version" {
  type    = string
  default = "8.0"
}


variable "lambda_s3_key" {
  type = string
  default = "lambda/personas_lambda.zip"
}

