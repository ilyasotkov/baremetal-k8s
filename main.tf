terraform {
  backend "remote" {
    organization = "ilyasotkov"

    workspaces {
      name = "baremetal-k8s"
    }
  }
}

variable "ssh_password" {
  type = string
}

resource "null_resource" "init" {
  triggers = {
    always = uuid()
  }

  connection {
    type     = "ssh"
    host     = "192.168.10.48"
    user     = "root"
    password = var.ssh_password
  }

  provisioner "remote-exec" {
    inline = [
      "apt-get update"
    ]
  }
}
