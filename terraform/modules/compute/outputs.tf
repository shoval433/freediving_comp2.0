output "key" {
  value = tls_private_key.rsa.private_key_pem
}

output "ec2_public_ip" {
  value = [for i in range(var.ec2-count) : aws_instance.prod_shoval_iac[i].public_ip]
}

output "ec2_id" {
  value = [for i in range(var.ec2-count) : aws_instance.prod_shoval_iac[i].id]
}
