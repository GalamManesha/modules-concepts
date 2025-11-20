module "dev_ec2" {
  source         = "./modules/module"
  instance_type  = "t3.small"
  ami_id         = "ami-0078a63645c7b8a87"
}
