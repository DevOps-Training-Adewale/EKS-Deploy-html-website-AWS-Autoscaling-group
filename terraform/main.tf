provider "aws" {
  region = var.aws_region
  access_key = AKIAZQ3DSREDOF7MO3SB
  secret_key = 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
}

resource "aws_launch_template" "app" {
  name          = "app-launch-template"
  image_id      = "ami-0c55b159cbfafe1f0" # Use the latest Amazon Linux 2 AMI
  instance_type = "t2.micro"

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y docker
              service docker start
              docker run -d -p 80:80 ${var.docker_image}
              EOF
}

resource "aws_autoscaling_group" "app" {
  launch_template {
    id      = aws_launch_template.app.id
    version = "$LATEST"
  }

  min_size         = 1
  max_size         = 3
  desired_capacity = 1

  vpc_zone_identifier = [var.subnet_id]

  tag {
    key                 = "Name"
    value               = "app-instance"
    propagate_at_launch = true
  }

  target_group_arns = [aws_lb_target_group.app.arn]
}

resource "aws_lb" "app" {
  name               = "app-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.security_group_id]
  subnets            = [var.subnet_id]
}

resource "aws_lb_target_group" "app" {
  name     = "app-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_listener" "app" {
  load_balancer_arn = aws_lb.app.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}

output "load_balancer_dns" {
  value = aws_lb.app.dns_name
}
