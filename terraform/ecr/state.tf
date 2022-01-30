terraform {
  backend "s3" {
    bucket         = "papa-tf"
    key            = "ecr/ecr.tfstate"
    region         = "eu-central-1"
    profile        = "test-infra"
    dynamodb_table = "papa-ecr-tf-lock"
  }
}

resource "aws_dynamodb_table" "papa-ecr-tf-lock" {
  name           = "papa-ecr-tf-lock"
  hash_key       = "LockID"
  read_capacity  = 5
  write_capacity = 5

  attribute {
    name = "LockID"
    type = "S"
  }
}
