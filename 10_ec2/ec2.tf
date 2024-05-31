resource "aws_instance" "app_server" {
  for_each               = toset(data.aws_subnets.default.ids)
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.app_server_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.instance_profile.name
  user_data              = file("install.sh")
  subnet_id              = each.value

  tags = {
    Name = "projet"
  }
}

resource "aws_security_group" "app_server_sg" {
  name        = "server_sg"
  description = "Allow specific ip to access the ec2"

  tags = {
    Name = "projet"
  }
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = "instance_profile"
  role = aws_iam_role.s3_write_access.name
}

resource "aws_vpc_security_group_ingress_rule" "allow_ip" {
  security_group_id = aws_security_group.app_server_sg.id
  cidr_ipv4         = var.allowed_ip_on_app_server
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "health_check" {
  security_group_id = aws_security_group.app_server_sg.id
  referenced_security_group_id = aws_security_group.lb_sg.id
  from_port   = 1080
  ip_protocol = "tcp"
  to_port     = 1080
}

resource "aws_vpc_security_group_egress_rule" "allow_external_communication" {
  security_group_id = aws_security_group.app_server_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_iam_role" "s3_write_access" {
  name = "s3_write"

  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role_policy.json
  inline_policy {
    name   = "write_access_tp_projet_bucket"
    policy = data.aws_iam_policy_document.projet_s3_write.json
  }

  tags = {
    Name = "projet"
  }
}
data "aws_iam_policy_document" "ec2_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "projet_s3_write" {
  statement {
    effect    = "Allow"
    actions   = ["s3:PutObject"]
    resources = ["${data.aws_s3_bucket.projet_bucket.arn}/can_be_written/*"]
  }
}