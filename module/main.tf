module "dev_ec2" {
  source        = "./modules/module"
  instance_type = "t3.small"
  ami           = "ami-087d1c9a513324697"
}

