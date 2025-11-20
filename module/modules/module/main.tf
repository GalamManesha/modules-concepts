resource "aws_instance" "this" {
  ami           = var.ami
  instance_type = var.instance_type

  tags = {
    Name        = "dev-ec2"
    Environment = " var.env"
  }
}

