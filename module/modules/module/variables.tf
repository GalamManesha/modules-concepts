variable "instance_type" {
  type    = string
  default = "t3.small"
}

variable "key_name" {
  type    = string
  default = "connect"
}

variable "ami" {
  type    = string
  default = "ami-001ce22601d4c605f"
}

variable "tags" {
  type    = string
  default = "variables-hello"
}

variable "region" {
  type    = string
  default = "ap-south-1"
}
