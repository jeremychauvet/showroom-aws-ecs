locals {
  region         = "eu-north-1"
  name           = "ghost"
  container_name = "ghost"
  container_port = 2368

  # Networking

  network = {
    vpc_id     = data.aws_vpcs.list.ids
    subnet_ids = data.aws_subnets.list.ids
    # cidr_blocks = data.aws_vpc.production.cidr_block_associations.cidr_block
  }

  # Billing and ABAC
  tags = {
    Name = local.name
  }
}
