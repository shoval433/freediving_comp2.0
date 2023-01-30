output "key" {
  value = tls_private_key.rsa.private_key_pem
}

output "ec2_public_ip" {
  value = aws_instance.prod_shoval_iac.public_ip
}
output "ec2_id" {
  value = aws_instance.prod_shoval_iac.id
}
