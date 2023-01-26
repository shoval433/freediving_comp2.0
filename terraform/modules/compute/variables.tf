variable "ami_prod" {
  default = "ami-03c476a1ca8e3ebdc"
  type = string
}
variable "Owner" {
  default = "Shoval.Astamker"
}
variable "instance_type_prod" {
  default = "t3a.micro"
  type = string
}
variable "region" {
  default = "eu-west-3"
  type = string
}
variable "tags" {
  default = {
    "Name" = "prod2_shoval_iac",
    "bootcamp"= "17",
    "expiration_date" = "26-02-23",
    "Owner" =	"Shoval.Astamker"
  }
  type = map
}
variable "ec2-count" {
  type        = number
  description = "how many ec2 to make"

  validation {
    condition     = var.ec2-count == 1 || var.ec2-count == 2
    error_message = "not valid number... enter 1 or 2"
  }
}
variable "ec2_name" {
  type = list(string)
  default = [ "prod1_shoval_iac","prod2_shoval_iac" ]
}
variable "vpc-id" {
  type = string
}
variable "subnets-id" {
  type        = list(any)
  description = "the subnets id"
}