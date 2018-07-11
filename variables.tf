provider "aws" {
  access_key = "${var.AWS_KEY}"
  secret_key = "${var.AWS_SECRET}"
  region     = "${var.region}"
}

variable "region" {
  description = "in witch region do you want to deploy?"
  default     = "eu-west-1"
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

variable "AWS_KEY" {
  default = ""
}

variable "AWS_SECRET" {
  default = ""
}

variable "delete_on_termination" {
  default = true
}

variable "volume_size_root" {
  default = 8
}

variable "key_name" {
  description = "in witch availability zone do you want to deploy?"
  default     = ""
}

variable "availability_zone" {
  description = "The existing availability_zone where you want to deploy SAP HANA. a, b, c, d"
  default     = "a"
}

variable "PublicSubnetIds" {
  type        = "list"
  description = "A list of VPC subnet IDs"
  default     = ["subnet-", "subnet-"]
}

variable "snsTopic" {
  default = "snsTopic"
}

variable "bucketName" {
  default = ""
}

variable "instance_type" {
  description = "Instance type for SAP instance"
  default     = "t2.micro"
}

variable "security_group_id" {
  description = "what is id of security group?"
  default     = "sg-"
}

variable "vpc_id" {
  description = "what is id of subnet_id?"
  default     = "vpc-"
}

variable "Environment" {
  description = "witch is your environment"
  default     = "Production"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  default     = {}
}
