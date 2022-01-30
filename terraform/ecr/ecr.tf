module "papa" {
  source                 = "cloudposse/ecr/aws"
  version                = "0.32.3"
  namespace              = "webapp"
  stage                  = "dev"
  name                   = "papa"
  principals_full_access = ["arn:aws:iam::007625393789:user/test-infra"]
}