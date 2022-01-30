variable "aws_region" {
  type    = string
  default = "eu-central-1"
}

## IAM Role to be granted ECR permissions
#data "aws_iam_role" "ecr" {
#  name = "ecr"
#}