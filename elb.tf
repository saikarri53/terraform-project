resource "aws_elb" "bar" {
  name               = "sai-terraform-elb"
  availability_zones = ["us-east-1a", "us-east-1b"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 5
    timeout             = 5
    target              = "HTTP:80/"
    interval            = 30
  }

  instances                 = [aws_instance.one.id, aws_instance.two.id]  # Directly reference instance IDs
  cross_zone_load_balancing = true   # ✅ This distributes traffic across AZs
  idle_timeout              = 400

  tags = {
    Name = "sai-tf-elb"
  }
}
