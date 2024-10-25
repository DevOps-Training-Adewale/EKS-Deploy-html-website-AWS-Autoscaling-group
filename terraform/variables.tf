variable "aws_region" {}
variable "vpc_id" {}
variable "subnet_ids" {
description = "List of subnet IDs"
  type        = list(string)
}
variable "security_group_id" {}
variable "docker_image" {}
variable "key_pair" {}