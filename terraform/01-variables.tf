variable "env" {
  description = "Name of the environment"
  type        = string
  default     = "pnadalini"
}

variable "region" {
  description = "Region used to deploy the template"
  type        = string
  default     = "us-east-1"
}

variable "s3_bucket" {
  description = "Bucket where lambda functions code is located"
  type        = string
  default     = "pnadalini-trambo"
}

variable "table_name" {
  description = "Name of the DynamoDB table"
  type        = string
}

variable "table_arn" {
  description = "Arn of the DynamoDB table"
  type        = string
}
