provider "aws" {
  region = var.region
}

resource "aws_instance" "this" {
  ami           = var.ami
  instance_type = var.instance_type

  tags = {
    Name        = "my-first-module"
    Environment = "dev"
  }
}

