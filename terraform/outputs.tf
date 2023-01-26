output "ec2s_ips" {
  description = "the ips of the ec2"
  value       = module.compute.prod_shoval_iac[*].public_ip
}

resource "local_file" "ip-for-tests" {
content  = module.compute.prod_shoval_iac[*].public_ip
filename = "../ec2_ip.txt"
}
