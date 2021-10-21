#Helm install of sample app on IKS
data "terraform_remote_state" "iksws" {
  backend = "remote"
  config = {
    organization = var.org
    workspaces = {
      name = var.ikswsname
    }
  }
}
data "external" "host" {
  program = ["bash", "./scripts/gethost.sh"]
  query = {
    url = local.kube_config.clusters[0].cluster.server
  }
}


variable "org" {
  type = string
}
variable "ikswsname" {
  type = string
}

locals {
  kube_config = yamldecode(data.terraform_remote_state.iksws.outputs.kube_config)
}

output "host" {
  value = data.external.host.result["host"]
}


