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

variable "apt_packages" {
  type    = list
  default = []
}

variable "connections" {
  type = list
  default = [
    "192.168.10.48",
    "192.168.10.51",
    "192.168.10.63"
  ]
}

resource "null_resource" "init" {
  count = length(var.connections)

  triggers = {
    always = uuid()
  }

  connection {
    type     = "ssh"
    host     = element(var.connections, count.index)
    user     = "root"
    password = var.ssh_password
  }

  provisioner "remote-exec" {
    inline = [
      "apt-get update -q",
      "apt-get install -yq ufw ${join(" ", var.apt_packages)}"
    ]
  }
}
