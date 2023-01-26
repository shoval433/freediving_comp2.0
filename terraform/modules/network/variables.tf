
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
variable "vpc_cidr" {
  type        = string
  default     = "42.0.0.0/16"
}
variable "subnet_cidr" {
  type        = list(string)
  default     = ["42.0.10.0/24","42.0.20.0/24"]
}
variable "vpc-name" {
  default = "shoval_vpc_iac"
}
variable "sub-name" {
  type        = list(string)
  default = [ "sub1-shoval","sub2-shoval" ]
  description = "subnets name"
}
variable "AZ" {
  description = "the first az to use"
  type        = list(any)
}
variable "sub-count" {
  type        = number
  description = "how many subnets to make"
  default     = 2

  validation {
    condition     = var.sub-count == 1 || var.sub-count == 2
    error_message = "not valid number... enter 1 or 2"
  }
}
