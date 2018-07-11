data "aws_ami" "node_app_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["wordpress*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "template_file" "userdata" {
  template = "${file("userdata.sh")}"

  vars {
    Timezone = "${var.Timezone}"
  }
}

resource "aws_iam_instance_profile" "EC2InstanceProfile" {
  role = "${aws_iam_role.EC2Role.name}"
}

resource "aws_launch_configuration" "as_conf" {
  name_prefix          = "terraform-lc-example-"
  image_id             = "${data.aws_ami.node_app_ami.id}"
  instance_type        = "${var.instance_type}"
  security_groups      = ["${var.security_group_id}"]
  key_name             = "${var.key_name}"
  iam_instance_profile = "${aws_iam_instance_profile.EC2InstanceProfile.id}"

  root_block_device {
    volume_type           = "gp2"
    volume_size           = "${var.volume_size_root}"
    delete_on_termination = "${var.delete_on_termination}"
  }

  associate_public_ip_address = true
  user_data                   = "${data.template_file.userdata.rendered}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "asg_conf" {
  name                 = "asg_conf"
  depends_on           = ["aws_launch_configuration.as_conf"]
  launch_configuration = "aws_launch_configuration.as_conf.name"
  load_balancers       = ["${aws_elb.app-balancer.id}"]
  health_check_type    = "ELB"
  launch_configuration = "${aws_launch_configuration.as_conf.name}"

  min_size            = 0
  max_size            = 0
  desired_capacity    = 0
  vpc_zone_identifier = ["${var.PublicSubnetIds}"]

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "test"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "scalingpolicy" {
  name                   = "scalingpolicy"
  scaling_adjustment     = 4
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = "${aws_autoscaling_group.asg_conf.name}"
}
