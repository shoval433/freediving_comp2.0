module "network" {
  source = "./modules/network"
  AZ           = var.AZs
  sub-count    = var.number
}

module "compute" {
  source = "./modules/compute"
  ec2-count  = var.number
  vpc-id     = module.network.vpc_id
  subnets-id = module.network.subnets
}
resource "null_resource" "name" {
  count = var.number
  triggers = {
    instance_id = module.compute.ec2_id[count.index]
  }

  depends_on = [module.compute]

  connection {
    type        = "ssh"
    user        = "ubuntu"
    host        = module.compute.ec2_public_ip[count.index]
    private_key = module.compute.key
  }
  provisioner "file" {
    source      = "../init"
    destination = "/home/ubuntu"
  }
  provisioner "remote-exec" {
    inline = [
      "cd init && bash init.sh ${var.VAR}",
    ]
  }

}
output "lb_arn" {
  description = "The ID and ARN of the load balancer we created"
  value       = module.compute.lb_group_arn
}