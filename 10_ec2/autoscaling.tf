resource "aws_launch_template" "server" {
  name_prefix   = "server"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
  user_data = filebase64("install.sh")
  vpc_security_group_ids = [aws_security_group.app_server_sg.id]

  iam_instance_profile {
    name = aws_iam_instance_profile.instance_profile.name
  }
}

resource "aws_autoscaling_group" "server_scaling_group" {
  availability_zones = var.availability_zones
  desired_capacity   = 2
  max_size           = 2
  min_size           = 2
  health_check_type = "ELB"

  launch_template {
    id      = aws_launch_template.server.id
    version =  aws_launch_template.server.latest_version
  }
}

resource "aws_autoscaling_attachment" "target_group_to_autoscaling_group" {
  autoscaling_group_name = aws_autoscaling_group.server_scaling_group.id
  lb_target_group_arn    = aws_lb_target_group.servers.id
}