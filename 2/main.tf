resource "aws_instance" "test_server" {
  ami           = var.machine_image
  instance_type = var.ec2_type
  tags = {
    "Name" = "test_server"
  }
}