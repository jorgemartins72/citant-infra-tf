data "aws_availability_zones" "availables" {}

/* Subnets públicas */
resource "aws_subnet" "subnet_publicas" {
  count                   = var.total_subnets
  vpc_id                  = aws_vpc.this.id
  cidr_block              = "10.0.${count.index + 1}.0/24"
  availability_zone       = data.aws_availability_zones.availables.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.tagname}_SUBNET_PUBLICA_${count.index + 1}"
  }
}

resource "aws_route_table" "public_rtb" {
  vpc_id     = aws_vpc.this.id
  depends_on = [aws_internet_gateway.igw]
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${var.tagname}_RTB_PUBLICA"
  }
}

/* Route table associations */
resource "aws_route_table_association" "rtb-association-public" {
  count          = var.total_subnets
  route_table_id = aws_route_table.public_rtb.id
  subnet_id      = aws_subnet.subnet_publicas.*.id[count.index]
}

output "subnets" {
  value = aws_subnet.subnet_publicas
}
