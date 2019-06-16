terraform {
  backend "remote" {
    organization = "ilyasotkov"

    workspaces {
      name = "baremetal-k8s"
    }
  }
}

# variable "ssh_password" {
#   type = string
# }

variable "apt_packages" {
  type    = list
  default = []
}

variable "hosts" {
  type = list
  default = [
    "192.168.10.48",
    "192.168.10.51",
    "192.168.10.63"
  ]
}

resource "null_resource" "nodes" {
  count = length(var.hosts)

  triggers = {
    always = uuid()
  }
  #
  # connection {
  #   type     = "ssh"
  #   host     = element(var.hosts, count.index)
  #   user     = "root"
  #   password = var.ssh_password
  # }
  #
  # provisioner "remote-exec" {
  #   inline = [
  #     "apt-get --version",
  #     # "apt-get update -q",
  #     # "apt-get install -yq ufw ${join(" ", var.apt_packages)}"
  #   ]
  # }

  provisioner "local-exec" {
    command = <<EOT
ansible-playbook -l "${element(var.hosts, count.index)}," -vv cluster.yml
EOT
  }
}
