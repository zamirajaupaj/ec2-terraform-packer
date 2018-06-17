# Create a new load balancer
/*
resource "aws_elb" "app-balancer" {
  name            = "app-balancer-terraform-elb"
  security_groups = ["${aws_security_group.elbsg.id}"]
  subnets         = ["${var.public_subnet}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags {
    Name = "node-terraform-elb"
  }
}
*/

