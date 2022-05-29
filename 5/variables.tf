variable "vpc_cidr" {
  type = string
}

variable "ingress_from_port" {
  type = number
}

variable "ingress_to_port" {
  type = number
}
variable "env" {
  type = string
}

variable "destination_cidr_range" {
  type = string
}

variable "subnet_cidr" {
  type = string
}

variable "az" {
    type = string
}

variable "key_name" {
    type = string
}