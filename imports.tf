data "aws_availability_zones" "available" {}

data "aws_vpcs" "list" {
  tags = {
    Name = "acme-vpc-production"
  }
}

data "aws_vpc" "production" {
  id = data.aws_vpcs.list.ids[0]
}

data "aws_subnets" "list" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpcs.list.ids[0]]
  }
}
