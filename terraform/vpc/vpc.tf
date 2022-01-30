module "papa" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.11.5"

  name = "papa"
  cidr = "10.10.0.0/16"

  azs             = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
  private_subnets = ["10.10.0.0/19", "10.10.32.0/19", "10.10.64.0/19"]
  public_subnets  = ["10.10.192.0/22", "10.10.196.0/22", "10.10.200.0/22"]

  enable_nat_gateway     = true
  single_nat_gateway     = false
  one_nat_gateway_per_az = true
  enable_vpn_gateway     = false
}

