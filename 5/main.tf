module "myapp-subnet" {
  source                 = "./module/vpc/"
  subnet_cidr            = var.subnet_cidr
  vpc_cidr               = var.vpc_cidr
  ingress_from_port      = var.ingress_from_port
  ingress_to_port        = var.ingress_to_port
  env                    = var.env
  destination_cidr_range = var.destination_cidr_range
  az = var.az
}

resource "aws_instance" "myapp" {
  subnet_id     = module.myapp-subnet.subnet_id
  ami           = "ami-05ba3a39a75be1ec4"
  instance_type = "t2.micro"
  associate_public_ip_address = true
  key_name = var.key_name
  vpc_security_group_ids = [module.myapp-subnet.sg_id]
  tags = {
    Name = join(":", [var.env, "myapp-server"])
  }
}