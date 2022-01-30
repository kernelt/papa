variable "aws_region" {
  type    = string
  default = "eu-central-1"
}

data "aws_eks_cluster" "cluster" {
  name = module.papa.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.papa.cluster_id
}