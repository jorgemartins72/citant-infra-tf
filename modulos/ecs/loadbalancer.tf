# resource "aws_alb" "ecs_cluster_alb" {
#   name = "${var.tagname}-CLUSTER-ALB"
#   internal = false
#   security_groups = [aws_security_group.sg.id]
#   subnets = "${[for s in aws_subnet.subnet_publicas.*.id : format("%s", s)]}"

#   tags = {
#     Name = "${var.tagname}-CLUSTER-ALB"
#   }
# }

# resource "aws_alb_listener" "ecs_alb_https_listener" {
#   load_balancer_arn = aws_alb.ecs_cluster_alb.arn
#   port              = 80
#   protocol          = "HTTP"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_alb_target_group.ecs_default_target_group.arn
#   }

#   depends_on = [aws_alb_target_group.ecs_default_target_group]
# }

# resource "aws_alb_target_group" "ecs_default_target_group" {
#   name = "${var.tagname}-CLUSTER-TG"
#   port = 80
#   protocol = "HTTP"
#   vpc_id   = aws_vpc.iac-vpc.id

#   tags = {
#     Name = "${var.tagname}-CLUSTER-TG"
#   }
# }