resource "aws_vpc" "main" {
  # https://www.terraform.io/docs/providers/aws/r/vpc.html
  cidr_block = "10.0.0.0/21"
  instance_tenancy = "default"
  enable_dns_support = true
  enable_dns_hostnames = false
  enable_classiclink = false
  enable_classiclink_dns_support = false
  assign_generated_ipv6_cidr_block = false
  tags {
    Name = "OpenVPN_VPC"
  }
}

resource "aws_subnet" "public_subnet" {
  # https://www.terraform.io/docs/providers/aws/r/subnet.html
  availability_zone = "eu-west-1a"
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = false
  assign_ipv6_address_on_creation = false
  vpc_id = "${aws_vpc.main.id}"
  tags {
    Name = "OpenVPN_PubSub"
  }
}

resource "aws_subnet" "private_subnet" {
  # https://www.terraform.io/docs/providers/aws/r/subnet.html
  availability_zone = "eu-west-1a"
  cidr_block = "10.0.2.0/24"
  map_public_ip_on_launch = false
  assign_ipv6_address_on_creation = false
  vpc_id = "${aws_vpc.main.id}"
  tags {
    Name = "OpenVPN_PriSub"
  }
}

resource "aws_internet_gateway" "internet_gw" {
  # https://www.terraform.io/docs/providers/aws/r/internet_gateway.html
  vpc_id = "${aws_vpc.main.id}"
  tags {
    Name = "OpenVPN_IG"
  }
}

resource "aws_eip" "nat" {
  # https://www.terraform.io/docs/providers/aws/r/eip.html
  vpc = true
  tags = {
    Name = "OpenVPN_RT"
  }
}

resource "aws_nat_gateway" "nat_gw" {
  # https://www.terraform.io/docs/providers/aws/r/nat_gateway.html
  allocation_id = "${aws_eip.nat.id}"
  subnet_id = "${aws_subnet.public_subnet.id}"
  tags {
    Name = "OpenVPN_NG"
  }

  depends_on = ["aws_internet_gatewtay.internet_gw"]
}

resource "aws_route_table" "public" {
  # https://www.terraform.io/docs/providers/aws/r/route_table.html
  vpc_id = "${aws_vpc.main.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.internet_gw.id}"
  }
  tags {
    Name = "PublicRouteTable"
  }
}

resource "aws_route_table" "private" {
  # https://www.terraform.io/docs/providers/aws/r/route_table.html
  vpc_id = "${aws_vpc.main.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.nat_gw.id}"
  }
  tags {
    Name = "PrivateRouteTable"
  }
}

resource "aws_route_table_association" "pub" {
  subnet_id = "${aws_subnet.public_subnet.id}"
  route_table_id = "${aws_route_table.public.id}"
}


resource "aws_route_table_association" "pvt" {
  subnet_id = "${aws_subnet.private_subnet.id}"
  route_table_id = "${aws_route_table.private.id}"
}

