
# Create a VPC
resource "aws_vpc" "shoval_vpc_iac" {
  cidr_block = var.vpc_cidr
  tags = {
    Name =  format("%s-%s",var.vpc-name,"${terraform.workspace}")
  }
}
# Create a Subnet
resource "aws_subnet" "sub_shoval_iac" {
  count      = var.sub-count
  vpc_id     = aws_vpc.shoval_vpc_iac.id
  cidr_block = var.subnet_cidr[count.index]
  availability_zone = var.AZ[count.index]
  map_public_ip_on_launch = true 
  tags = {
    Name = format("%s-%s",var.sub-name[count.index],"${terraform.workspace}")
  }
}

# Create a IG
resource "aws_internet_gateway" "internet_gateway_shoval_iac" {
  vpc_id = aws_vpc.shoval_vpc_iac.id

  tags = {
    Name = "internet_gateway_shoval_iac-${terraform.workspace}"
  }
}
# Create a route
resource "aws_route_table" "shoval_route_iac" {
  vpc_id = aws_vpc.shoval_vpc_iac.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway_shoval_iac.id
  }
  tags = {
    "Name" = "shoval_route_iac-${terraform.workspace}"
  }
}
# association subnet
resource "aws_route_table_association" "sub_shoval_iac_ass" {
  count = var.sub-count
  subnet_id      = aws_subnet.sub_shoval_iac[count.index].id
  route_table_id = aws_route_table.shoval_route_iac.id
}
