# papa infra

Test Assignment\
This infra is built using https://github.com/terraform-aws-modules and some others.\
To be succesful of using this repo, the following tools are needed

- awscli 2.4.15
- kubernetes-cli 1.23.3
- eks 1.21
- helm 3.80
- terraform 1.1.4

How to use
- Obtain access to your AWS account -> https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html using profile name __test-infra__
- Edit _terraform/rds/rds.tf_:__[16,21]__
- Do ask your NRE team about _terraform/vpc/vpc.tf_:__[6-10]__  
- Run _terraform init|apply_ in that order: vpc, eks, ecr, rds. For the first-run, __lock__ section in _state.tf_ must be commented!
- Edit _webapp/docker/app/database.ini_:__[2,5]__
- Edit _webapp/docker/helm/values.ini_:__[8,50]__
- Obtain access to your AWS ECR -> https://docs.aws.amazon.com/cli/latest/reference/ecr/get-login-password.html and execute __docker login__
- Invoke _webapp/docker/build_push.sh_
- Run _helm install papa-webapp . -n papa-webapp_
- Send a http request towards a newly created alb using one of its uris: __/__, __/client-ip__, __/client-ip/list__


Tech debt
- route53-controller
- atlantis
- service mesh
- gitops
- aws SGs aren't automated
- encryption for sensetive data (network, disks, passwords)
- Refactoring of smelly main.py :)