terraform {
  backend "remote" {
    organization = "ilyasotkov"

    workspaces {
      name = "baremetal-k8s"
    }
  }
}
