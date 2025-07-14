# 공식 AMI를 조회할 data 소스 정의
data "aws_ami" "latest_amazon_linux2" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}
	
# IAM Instance Profile 선언
resource "aws_iam_instance_profile" "vod_media" {
  name = "vod-media-profile"   # 실제 AWS Console에 있는 이름과 동일하게
  role = "vod-media-role"        # 기존에 만드신 IAM Role 이름
}

# EC2 Instance Profile(→ vod-media-role) 적용
resource "aws_instance" "web" {
  ami = data.aws_ami.latest_amazon_linux2.id  # 동적 할당!
  instance_type = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.vod_media.name

  # 이하 기존 속성들
  subnet_id = var.subnet_id
  security_groups = var.security_group_ids
  key_name = var.key_name
  user_data = file("${path.module}/user_data.sh")
}

# CD to Launch Template + Auto Scaling Group
resource "aws_launch_template" "web_lt" {
	name_prefix = "${var.env}-lt-"
	image_id = data.aws_ami.latest_amazon_linux2.id
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