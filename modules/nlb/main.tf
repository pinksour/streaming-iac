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

  # TCP 프로토콜인 경우 path 속성 제거
  health_check {
    protocol            = each.value.protocol
    port                = each.value.port
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 2

    # HTTP/HTTPS 일 때만 path 지정
    #dynamic "path" {
    #  for_each = contains(["HTTP", "HTTPS"], upper(each.value.protocol)) ? [1] : []
    #  content { value = each.value.health_check_path }

    path = each.value.protocol == "HTTP" || each.value.protocol == "HTTPS" ? each.value.health_check_path : null
    #}
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
  # var.targets 각 항목에서 instance_ids 리스트를 꺼내
  # "<tg이름>-<인스턴스ID>"를 맵 키로, 값으로는 { tg, id } 오브젝트를 생성
  for_each = {
    for tg_name, cfg in var.targets :
    # 각 instance_id별로 고유 키 생성
    for id in cfg.instance_ids :
    "${tg_name}-${id}" => { tg = tg_name, id = id }
  }

  target_group_arn    = aws_lb_target_group.tg[each.value.tg].arn
  target_id           = each.value.id
  port                = aws_lb_target_group.tg[each.value.tg].port
}

output "nlb_dns" { value = aws_lb.nlb.dns_name }