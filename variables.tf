provider "aws" {
  access_key = "${var.AWS_KEY}"
  secret_key = "${var.AWS_SECRET}"
  region     = "${var.region}"
}

variable "region" {
  description = "in witch region do you want to deploy?"
}

variable "Hostname" {
  default = "Hostname"
}

variable "Password" {
  default = "test"
}

variable "Timezone" {
  default = "Europe/Rome"
}

variable "AWS_KEY" {}

variable "AWS_SECRET" {}

variable "delete_on_termination" {
  default = true
}

variable "volume_size_root" {
  default = 8
}

variable "key_name" {
  description = "in witch availability zone do you want to deploy?"
}

variable "availability_zone" {
  description = "The existing availability_zone where you want to deploy SAP HANA. a, b, c, d"
  default     = "a"
}

variable "public_subnet_1" {}

variable "instance_type" {
  description = "Instance type for SAP instance"
  default     = "t2.micro"
}

variable "security_group_id" {
  description = "what is id of security group?"
}

variable "public_subnet" {
  description = "what is id of subnet_id?"
}

variable "vpc_id" {
  description = "what is id of subnet_id?"
}

variable "Environment" {
  description = "witch is your environment"
  default     = "Production"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  default     = {}
}
