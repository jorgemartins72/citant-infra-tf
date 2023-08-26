# /* NAT */
# resource "aws_nat_gateway" "nat" {
#   allocation_id = aws_eip.nat_eip.id
#   subnet_id     = element(aws_subnet.subnet_publicas.*.id, 0)
#   depends_on    = [aws_internet_gateway.igw]

#   tags = {
#     Name = "${var.tagname}-NAT-GW"
#   }
# }

/* Subnets privadas */
# resource "aws_subnet" "subnet_privadas" {
#   count                   = 3
#   vpc_id                  = aws_vpc.iac-vpc.id
#   cidr_block              = "10.0.${count.index + 4}.0/24"
#   availability_zone       = data.aws_availability_zones.availables.names[format("%04d", count.index + 3)]
#   map_public_ip_on_launch = false
#   tags = {
#     Name = "${var.tagname}_SUBNET_PRIVADA_${count.index + 1}"
#   }
# }

# resource "aws_route_table" "private_rtb" {
#   vpc_id = aws_vpc.iac-vpc.id
#   route {
#     cidr_block     = "0.0.0.0/0"
#     nat_gateway_id = aws_nat_gateway.nat.id
#   }
#   tags = {
#     Name = "${var.tagname}_RTB_PRIVADA"
#   }
# }


# resource "aws_route_table_association" "rtb-association-private" {
#   count          = 3
#   route_table_id = aws_route_table.private_rtb.id
#   subnet_id      = aws_subnet.subnet_privadas.*.id[count.index]
# }
