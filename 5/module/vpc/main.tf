resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
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
  cidr_block = var.subnet_cidr
  availability_zone = var.az
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
  destination_cidr_block    = var.destination_cidr_range
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

resource "aws_security_group_rule" "ingress-rule-in" {
  type              = "ingress"
  from_port         = var.ingress_from_port
  to_port           = var.ingress_to_port
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sg.id
}
