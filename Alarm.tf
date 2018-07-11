############# Cloudwatch alarm for Hana Root ###########################

resource "aws_autoscaling_policy" "as_policy" {
  name                   = "as_policy-terraform-test"
  scaling_adjustment     = 4
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = "${aws_autoscaling_group.asg_conf.name}"
}

resource "aws_cloudwatch_metric_alarm" "RootAlarm" {
  alarm_name                = "RootAlarm"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = 5
  metric_name               = "DiskSpaceUtilization"
  namespace                 = "System/Linux"
  period                    = 60
  statistic                 = "Average"
  threshold                 = 90
  alarm_description         = "Send an alarm when the Disk utilization is higher than threshold"
  insufficient_data_actions = []

  dimensions {
    AutoScalingGroupName = "${aws_autoscaling_group.asg_conf.name}"
    MountPath            = "/"
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = ["${aws_sns_topic.snsTopic.arn}"]
}

############# Cloudwatch alarm for Recover ###########################
resource "aws_cloudwatch_metric_alarm" "StatusCheckAlarm" {
  alarm_name                = "StatusCheckAlarm"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = 2
  metric_name               = "StatusCheckFailed_System"
  namespace                 = "AWS/EC2"
  period                    = 60
  statistic                 = "Average"
  threshold                 = 0
  alarm_description         = "Trigger a recovery when instance status check fails for 5 consecutive minutes."
  insufficient_data_actions = []

  dimensions {
    AutoScalingGroupName = "${aws_autoscaling_group.asg_conf.name}"
  }

  alarm_actions = [
    "arn:aws:automate:${var.region}:ec2:recover",
    "${aws_sns_topic.snsTopic.arn}",
  ]
}
