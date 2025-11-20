variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.small"
}

variable "ami" {
  description = "AMI id to use"
  type        = string
  default     = "ami-087d1c9a513324697"
}
variable "region" {
  type    = string
  default = "ap-south-1"
}
variable "region" {
  type    = string
  default = "ap-south-1"
}
variable "env" {
  type = string
  default = "dev"
  
}


