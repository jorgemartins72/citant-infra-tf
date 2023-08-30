resource "aws_security_group" "security_group_alb" {
  vpc_id      = aws_vpc.this.id
  name        = "${var.projeto}-alb-sg"
  description = "Grupo de seguranca ALB ${var.tagname}"
  depends_on  = [aws_vpc.this]

  ingress = [
    {
      description      = "HTTPS"
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    # {
    #   description      = "HTTP"
    #   from_port        = 80
    #   to_port          = 80
    #   protocol         = "tcp"
    #   cidr_blocks      = ["0.0.0.0/0"]
    #   ipv6_cidr_blocks = []
    #   prefix_list_ids  = []
    #   security_groups  = []
    #   self             = false
    # },
  ]

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    prefix_list_ids = []
  }

  tags = {
    Name = "${var.tagname}-ALB-SG"
  }
}
output "security_group_alb_id" {
  value = aws_security_group.security_group_alb.id
}
