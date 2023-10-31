module "test_network" {
  source = "git::https://github.com/friends-ce-3-group/terraform-aws-network.git?ref=v0.1.4"

  vpc_cidr = "30.0.0.0/16"

  enable_dns_hostnames = true

  enable_dns_support = true

  vpc_tags = {
    Name = "friends-vpc"
  }

  map_public_ip_on_launch = true

  public_subnets = {
    us_west_2a_pub_subnet = {
      cidr_block        = "30.0.1.0/24"
      availability_zone = "us-west-2a"
    }
    us_west_2b_pub_subnet = {
      cidr_block        = "30.0.2.0/24"
      availability_zone = "us-west-2b"
    }
  }

  tags_public_subnet = {
    Name = "public subnets"
  }

  private_subnets = {
    us_west_2a_pvt_subnet = {
      cidr_block        = "30.0.3.0/24"
      availability_zone = "us-west-2a"
    }
    us_west_2b_pvt_subnet = {
      cidr_block        = "30.0.4.0/24"
      availability_zone = "us-west-2b"
    }
  }

  tags_private_subnet = {
    Name = "private subnets"
  }
}