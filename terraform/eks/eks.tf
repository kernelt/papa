module "papa" {
  source  = "terraform-aws-modules/eks/aws"
  version = "18.2.3"

  enable_irsa = true

  cluster_name                    = "papa"
  cluster_version                 = "1.21"
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  cluster_addons = {
    coredns = {
      resolve_conflicts = "OVERWRITE"
    }
    kube-proxy = {}
    vpc-cni = {
      resolve_conflicts = "OVERWRITE"
    }
  }

  vpc_id     = data.terraform_remote_state.vpc.outputs.papa_vpc_id
  subnet_ids = data.terraform_remote_state.vpc.outputs.papa_vpc_subnets

  eks_managed_node_group_defaults = {
    ami_type       = "AL2_x86_64"
    disk_size      = 10
    instance_types = ["c5a.xlarge"]
  }

  eks_managed_node_groups = {

    #ami_type = "ami-0c2fefb5836973845"

    blue = {
      min_size     = 1
      max_size     = 3
      desired_size = 1

      instance_types = ["c5a.xlarge"]
    }
    green = {
      min_size     = 1
      max_size     = 3
      desired_size = 1

      instance_types = ["c5a.xlarge"]
    }
  }
}

resource "kubernetes_namespace" "papa_webapp" {
  metadata {
    annotations = {
      name = "papa-webapp"
    }

    name = "papa-webapp"
  }
}

# resource "kubernetes_namespace" "ingress_nginx" {
#   metadata {
#     annotations = {
#       name = "ingress-nginx"
#     }

#     name = "ingress-nginx"
#   }
# }

# resource "helm_release" "ingress_nginx" {
#   name      = "ingress-nginx"
#   namespace = "ingress-nginx"

#   repository = "https://kubernetes.github.io/ingress-nginx"
#   chart      = "ingress-nginx"

#   set {
#     name  = "controller.service.type"
#     value = "ClusterIP"
#   }

#   set {
#     name  = "defaultBackend.enabled"
#     value = true
#   }
# }

module "load_balancer_controller" {
  source  = "DNXLabs/eks-lb-controller/aws"
  version = "0.5.1"

  cluster_identity_oidc_issuer     = module.papa.cluster_oidc_issuer_url
  cluster_identity_oidc_issuer_arn = module.papa.oidc_provider_arn
  cluster_name                     = module.papa.cluster_id
  helm_chart_version               = "1.3.3"
}


# module "nginx-controller" {
#   source                      = "terraform-iaac/nginx-controller/helm"
#   chart_version               = "4.0.16"
#   controller_kind             = "Deployment"
#   version                     = "2.0.0"
#   disable_heavyweight_metrics = true

#   additional_set = [
#     {
#       name  = "alb.ingress.kubernetes.io/load-balancer-name"
#       value = "papa-lb"
#       type  = "string"
#     },
#     {
#       name  = "alb.ingress.kubernetes.io/scheme"
#       value = "internet-facing"
#       type  = "string"
#     }
#   ]
# }
