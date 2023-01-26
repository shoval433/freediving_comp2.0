resource "null_resource" "example" {
  triggers = {
    instance_id = module.compute.prod_shoval_iac[*].id
  }
  
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ubuntu"
      host        = module.compute.prod_shoval_iac[*].public_ip
      private_key = module.compute.ssh-key.content
    }

    inline = [
      "echo hi",
    ]
  }
}