resource "aws_launch_template" "web_lt" {
	name_prefix = "${var.env}-lt-"
	image_id = var.ami_id
	instance_type = var.instance_type
	user_data = file("${path.module}/user_data.sh")
	security_group_names = [aws_security_group.web.name]
	key_name = var.key_name
}

resource "aws_autoscaling_group" "web_asg" {
	name = "${var.env}-asg-web"
	launch_template {
		id = aws_launch_template.web_lt.id
		version = "$$Latest"
	}
	vpc_zone_identifier = var.subnet_ids
	min_size = var.asg_min
	max_size = var.asg_max
	target_group_arns = var.target_group_arns
	health_check_type = "ELB"
}