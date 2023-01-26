output "vpc_id" {
  description = "ID of project VPC"
  value       = aws_vpc.shoval_vpc_iac.id
}

output "subnets" {
  description = "ID of project subnet"
  value       = tolist(aws_subnet.sub_shoval_iac[*].id)
}



