
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
variable "number" {
  type = number
  description = "how many ec2 and subnets to upload"
  default = 2
}
variable "AZs" {
  type = list
  description = "the AZ you want to use"
  default = ["eu-west-3a", "eu-west-3b"]
}