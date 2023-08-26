# resource "aws_instance" "ec2-1" {
#   ami = "ami-053b0d53c279acc90"
#   instance_type = "t2.micro"
#   subnet_id = "${element(aws_subnet.subnet_publicas.*.id, 0)}"
#   vpc_security_group_ids = [aws_security_group.sg.id]
#   key_name = "tf"
#   tags = {
#     Name = "TESTE EC2 1"
#   } 
# }

# resource "aws_instance" "ec2-2" {
#   ami = "ami-053b0d53c279acc90"
#   instance_type = "t2.micro"
#   subnet_id = "${element(aws_subnet.subnet_privadas.*.id, 0)}"
#   vpc_security_group_ids = [aws_security_group.sg.id]
#   key_name = "tf"
#   tags = {
#     Name = "TESTE EC2 2"
#   } 
# }