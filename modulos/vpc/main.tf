resource "aws_vpc" "this" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true
  depends_on           = [aws_vpc_dhcp_options.dhcp]
  tags = {
    Name = "${var.tagname}_VPC"
  }
}

/* Internet gateway for the public subnet */
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id
  tags = {
    Name = "${var.tagname}_IGW"
  }
}

/* Elastic IP for NAT */
resource "aws_eip" "nat_eip" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.igw]
  tags = {
    Name = "${var.tagname}_EIP"
  }
}

resource "aws_vpc_dhcp_options" "dhcp" {
  domain_name         = "ec2.internal"
  domain_name_servers = ["AmazonProvidedDNS"]
  tags = {
    Name = "${var.tagname}_DHCP"
  }
}

resource "aws_vpc_dhcp_options_association" "dns_resolver" {
  vpc_id          = aws_vpc.this.id
  dhcp_options_id = aws_vpc_dhcp_options.dhcp.id
}

output "vpc_id" {
  value = aws_vpc.this.id
}
