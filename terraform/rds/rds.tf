module "papa" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 3.5.0"

  identifier = "papa"

  engine               = "postgres"
  engine_version       = "11.10"
  instance_class       = "db.t2.micro"
  family               = "postgres11"
  major_engine_version = "11"
  allocated_storage    = 5

  name     = "papaapp"
  username = "bunny"
  password = ""
  port = 5432

  iam_database_authentication_enabled = true

  vpc_security_group_ids = [""]

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  create_monitoring_role = false

  subnet_ids = data.terraform_remote_state.vpc.outputs.papa_vpc_subnets

  deletion_protection = false

  parameters = [
    {
      name  = "autovacuum"
      value = 1
    },
    {
      name  = "client_encoding"
      value = "utf8"
    },
    {
      name  = "rds.force_ssl"
      value = 0
    },
  ]

}