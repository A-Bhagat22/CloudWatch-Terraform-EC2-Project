provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
}

resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnet_cidr
}

resource "aws_security_group" "ec2_sg" {
  name   = "ec2-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web" {
  ami                    = var.ami_id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.main.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  monitoring             = true
  associate_public_ip_address = true

  tags = {
    Name = "CloudWatch-Monitored-EC2"
  }

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y amazon-cloudwatch-agent
              /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
                -a fetch-config -m ec2 -c ssm:${aws_ssm_parameter.cw_cfg.name} -s
              EOF
}

resource "aws_ssm_parameter" "cw_cfg" {
  name  = "/cloudwatch/agent/config"
  type  = "String"
  value = file("config.json")
}

resource "aws_sns_topic" "alarm_topic" {
  name = "ec2-alarm-topic"
}

resource "aws_sns_topic_subscription" "email_sub" {
  topic_arn = aws_sns_topic.alarm_topic.arn
  protocol  = "email"
  endpoint  = var.email
}

resource "aws_cloudwatch_metric_alarm" "cpu_alarm" {
  alarm_name          = "ec2_high_cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  threshold           = var.cpu_threshold
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  dimensions = {
    InstanceId = aws_instance.web.id
  }
  alarm_actions = [aws_sns_topic.alarm_topic.arn]
}
