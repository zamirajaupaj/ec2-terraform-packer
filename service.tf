data "aws_ami" "node_app_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["zamira-test*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "template_file" "userdata" {
  template = "${file("userdata.sh")}"

  vars {
    Hostname = "${var.Hostname}"
    Region   = "${var.region}"
    Password = "${var.Password}"
    Timezone = "${var.Timezone}"
    Bucket   = "bucket-zamira"
  }
}

resource "aws_iam_instance_profile" "EC2InstanceProfile" {
  role = "${aws_iam_role.EC2Role.name}"
}

resource "aws_launch_configuration" "as_conf" {
  name_prefix = "terraform-lc-example-"

  #image_id    = "ami-58d7e821"

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

resource "aws_autoscaling_group" "austoscaling" {
  #name                 = "terraform-asg-example"
  #load_balancers       = ["${aws_elb.app-balancer.id}"]
  #health_check_type    = "ELB"
  launch_configuration = "${aws_launch_configuration.as_conf.name}"

  min_size         = 1
  max_size         = 1
  desired_capacity = 1

  vpc_zone_identifier = ["${var.public_subnet}", "${var.public_subnet_1}"]

  #vpc_zone_identifier = ["${lookup(var.private_subnet, var.availability_zone)}"]

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
  autoscaling_group_name = "${aws_autoscaling_group.austoscaling.name}"
}
