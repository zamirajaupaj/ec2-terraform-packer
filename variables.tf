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

variable "AWS_SECRET" {
}

variable "delete_on_termination" {
  default = true
}

variable "volume_size_root" {
  default = 8
}

variable "key_name" {
  type        = "map"
  description = "in witch availability zone do you want to deploy?"

  default = {
    eu-west-1      = "test"
    eu-west-2      = "test"
    eu-central-1   = "test"
    us-east-1      = "test"
    us-east-2      = "test"
    us-west-1      = "test"
    us-west-2      = "test"
    ca-central-1   = "test"
    eu-west-3      = "test"
    ap-northeast-1 = "test"
    ap-northeast-2 = "test"
    ap-southeast-1 = "test"
    ap-southeast-2 = "test"
    ap-south-1     = "test"
    sa-east-1      = "test"
  }
}

variable "availability_zone" {
  description = "The existing availability_zone where you want to deploy SAP HANA. a, b, c, d"
}

variable "private_subnet" {
  type        = "map"
  description = "in witch availability zone do you want to deploy?"

  default = {
    "a" = "subnet-"
    "b" = "subnet-"
    "c" = "subnet-"
  }
}

variable "instance_type" {
  description = "Instance type for SAP instance"
  default     = "t2.micro"
}

variable "security_group_id" {
  description = "what is id of security group?"
  default     = "sg-"
}

variable "public_subnet" {
  description = "what is id of subnet_id?"
  default     = "subnet-"
}

variable "Environment" {
  description = "witch is your environment"
  default     = "Production"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  default     = {}
}
