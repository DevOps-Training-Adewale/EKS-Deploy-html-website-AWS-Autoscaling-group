provider "aws" {
  region = var.aws_region
 
}

resource "aws_launch_template" "app" {
  name          = "app-launch-template"
  image_id      = "ami-0cad6ee50670e3d0e" # Use the latest Amazon Linux 2 AMI
  instance_type = "t2.micro"
  key_name      = var.key_pair

  user_data = base64encode(<<-EOF
              #!/bin/bash
              sudo apt update
              sudo apt install docker.io -y
              sudo usermod -aG docker ubuntu
              sudo systemctl restart docker
              sudo chmod 777 /var/run/docker.sock
              docker run -d -p 80:80 ${var.docker_image}
              EOF
  )
}

resource "aws_autoscaling_group" "app" {
  launch_template {
    id      = aws_launch_template.app.id
    version = "1"
  }

  min_size         = 1
  max_size         = 3
  desired_capacity = 1

  vpc_zone_identifier = tolist(var.subnet_ids)

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
  subnets            = tolist(var.subnet_ids)
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