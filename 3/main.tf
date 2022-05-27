resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    "Name" = join("-", [var.env, "vpc"])
  }
}

resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    "Name" = join("-", [var.env, "ig"])
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    "Name" = join("-", [var.env, "subnet"])
  }
}

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.vpc.id

  route = []

  tags = {
    "Name" = join("-", [var.env, "rt"])
  }
}

resource "aws_route" "r" {
  route_table_id = aws_route_table.route_table.id
  gateway_id     = aws_internet_gateway.ig.id
  depends_on     = [aws_route_table.route_table]
  destination_cidr_block    = "0.0.0.0/0"
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.route_table.id
}

resource "aws_security_group" "sg" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.vpc.id
  tags = {
    "Name" = join("-", [var.env, "sg"])
  }
}

resource "aws_security_group_rule" "ingress-rule" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sg.id
}

resource "aws_instance" "ec2" {
  instance_type          = var.instance_size
  ami                    = var.ec2_image
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.sg.id]
  key_name               = data.aws_key_pair.key.key_name
  associate_public_ip_address = true
  tags = {
    "Name" = join("-", [var.env, "server"])
  }
}
