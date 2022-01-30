terraform {
  backend "s3" {
    bucket         = "papa-tf"
    key            = "eks/eks.tfstate"
    region         = "eu-central-1"
    profile        = "test-infra"
    dynamodb_table = "papa-eks-tf-lock"
  }
}

resource "aws_dynamodb_table" "papa-eks-tf-lock" {
  name           = "papa-eks-tf-lock"
  hash_key       = "LockID"
  read_capacity  = 5
  write_capacity = 5

  attribute {
    name = "LockID"
    type = "S"
  }
}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket  = "papa-tf"
    key     = "vpc/vpc.tfstate"
    region  = "eu-central-1"
    profile = "test-infra"
  }
}