resource "aws_alb" "ecs_cluster_alb" {
  name            = "${var.tagname}-CLUSTER-ALB"
  internal        = false
  security_groups = [var.security_group_id]
  subnets         = [for s in var.subnets.*.id : format("%s", s)]

  tags = {
    Name = "${var.tagname}-CLUSTER-ALB"
  }
}

resource "aws_alb_target_group" "ecs_default_target_group" {
  name        = "${var.tagname}-TG"
  port        = 5000
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  tags = {
    Name = "${var.tagname}-TG"
  }
}

resource "aws_route53_record" "ecs_alb_domain_record" {
  name    = "api.${var.dominio}"
  zone_id = var.website_zone_id
  type    = "A"

  alias {
    evaluate_target_health = false
    name                   = aws_alb.ecs_cluster_alb.dns_name
    zone_id                = aws_alb.ecs_cluster_alb.zone_id
  }
}

resource "aws_alb_listener" "ecs_alb_https_listener" {
  load_balancer_arn = aws_alb.ecs_cluster_alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"
  certificate_arn   = var.website_certificado_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.ecs_default_target_group.arn
  }

  depends_on = [aws_alb_target_group.ecs_default_target_group]
}

output "target_group_arn" {
  value = aws_alb_target_group.ecs_default_target_group.arn
}
