output "dev_public_ip" {
  value = aws_instance.my_server[0].public_ip
}

output "prod_public_ip" {
  value = aws_instance.my_server[1].public_ip
}