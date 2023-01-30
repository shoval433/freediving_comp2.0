output "key" {
  value = tls_private_key.rsa.private_key_pem
}

output "ec2_public_ip" {
  type = list
  value = aws_instance.prod_shoval_iac.public_ip
}
output "ec2_id" {
  type = list
  value = aws_instance.prod_shoval_iac.id
}