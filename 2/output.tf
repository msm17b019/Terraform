output "public_ip" {
  value = aws_instance.test_server.public_ip
}

output "private_ip" {
  value = aws_instance.test_server.private_ip
}