variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "ami" {
  description = "AMI id to use"
  type        = string
}

variable "env" {
  description = "Environment tag"
  type        = string
}
