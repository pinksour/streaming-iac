# 1) 중첩 루프로 생성된 객체 리스트
locals {
  # var.targets 를 평탄화(flatten)해서 attachments 리스트 생성
  attachments_list = flatten ([
    for tg_name, cfg in var.targets : [
      for id in cfg.instance_ids : {
        key = "${tg_name}-${id}"
        tg = tg_name
        id = id
      }
    ]
  ])
}

# 2) 리스트 → map 변환
locals {
  attachments = {
    for att in local.attachments_list :
    att.key => {
      tg = att.tg,
      id = att.id
    }
  }
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
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 2

    # HTTP/HTTPS 일 때만 path, TCP 일 땐 null 처리
    path = (
      each.value.protocol == "HTTP" || each.value.protocol == "HTTPS"
    ) ? each.value.health_check_path : null
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

# 여기엔 중첩된 for 없이 하나의 map literal만 사용
resource "aws_lb_target_group_attachment" "attach" {
  for_each = local.attachments

  target_group_arn = aws_lb_target_group.tg[each.value.tg].arn
  target_id           = each.value.id
  port                = aws_lb_target_group.tg[each.value.tg].port
}

output "nlb_dns" {
  value = aws_lb.nlb.dns_name
}