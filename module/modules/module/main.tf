provider "aws" {
  region = var.region
}

resource "aws_instance" "example" {
  instance_type = var.instance_type
  key_name      = var.key_name
  ami           = var.ami
  tags = {
    Name = var.tags
  }
}
