module "network" {
  source = "./modules/network"

  # vpc-name     = var.vpc-name
#   subnets-name = var.subnets-names
  AZ           = var.AZs
  sub-count    = var.number
}

module "compute" {
  source = "./modules/compute"

#   ami        = var.ec2-image
#   ec2-names  = var.ec2-names
  ec2-count  = var.number
  vpc-id     = module.network.vpc_id
  subnets-id = module.network.subnets
}