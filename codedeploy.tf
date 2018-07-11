resource "aws_iam_role" "RoleCodeDeploy" {
  name = "RoleCodeDeploy"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "codedeploy.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "PolicyCodeDeploy" {
  name = "PolicyCodeDeploy"
  role = "${aws_iam_role.RoleCodeDeploy.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "autoscaling:CompleteLifecycleAction",
        "autoscaling:DeleteLifecycleHook",
        "autoscaling:DescribeAutoScalingGroups",
        "autoscaling:DescribeLifecycleHooks",
        "autoscaling:PutLifecycleHook",
        "autoscaling:RecordLifecycleActionHeartbeat",
        "codedeploy:*",
        "ec2:DescribeInstances",
        "ec2:DescribeInstanceStatus",
        "tag:GetTags",
        "tag:GetResources",
        "sns:Publish",
        "CloudWatch:*",
        "log:*",
        "s3:*"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_codedeploy_app" "myapp" {
  name = "myapp"
}

resource "aws_codedeploy_deployment_group" "myapp" {
  deployment_group_name = "prod"
  app_name              = "${aws_codedeploy_app.myapp.name}"
  service_role_arn      = "${aws_iam_role.RoleCodeDeploy.arn}"

  deployment_config_name = "CodeDeployDefault.OneAtATime"
  autoscaling_groups     = ["${aws_autoscaling_group.asg_conf.name}"]

  ec2_tag_filter {
    type  = "KEY_AND_VALUE"
    key   = "codedeploy"
    value = "true"
  }

  trigger_configuration {
    trigger_events     = ["DeploymentFailure"]
    trigger_name       = "trigger"
    trigger_target_arn = "${aws_sns_topic.snsTopic.arn}"
  }

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  alarm_configuration {
    alarms  = ["Alarm"]
    enabled = true
  }
}
