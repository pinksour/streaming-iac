locals {
  attachments = flatten([
  for tg_key, tg_val in var.targets : [
    for inst_id in tg_val.instance_ids : {
      name = tg_key
      instance_id = inst_id
      }
    ]
  ])
}

resource "aws_lb" "nlb" {
  name               = "${var.name}-nlb"
  internal           = true
  load_balancer_type = "network"
  subnets            = var.subnet_ids
  security_groups    = [var.sg_nlb_id]
}

resource "aws_lb_target_group" "tg" {
  for_each = var.targets
  name     = "${var.name}-tg-${each.key}"
  port     = each.value.port
  protocol = each.value.protocol
  vpc_id   = var.vpc_id

  health_check {
    protocol            = each.value.protocol
    port                = each.value.port
    path                = each.value.health_check_path
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "listener" {
  for_each          = var.targets
  load_balancer_arn = aws_lb.nlb.arn
  port              = each.value.port
  protocol          = each.value.protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg[each.key].arn
  }
}

resource "aws_lb_target_group_attachment" "attach" {
  for_each = {
    for att in local.attachments : "${att.name}-${att.instance_id}" => att
  }

  target_group_arn    = aws_lb_target_group.tg[each.value.name].arn
  target_id           = each.value.instance_id
  port                = aws_lb_target_group.tg[each.value.name].port
}

output "nlb_dns" { value = aws_lb.nlb.dns_name }