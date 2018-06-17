######### IAM Role to Grant Permissions to S3 ##############
resource "aws_iam_role" "EC2Role" {
  path = "/"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

######### IAM Policy to Grant Permissions to S3 $ Cloudwatch ###############
resource "aws_iam_role_policy" "Ec2Policy" {
  depends_on = ["aws_iam_role.EC2Role"]
  name       = "CloudwatchPolicy"
  role       = "${aws_iam_role.EC2Role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
	  {
      "Action": [
        "cloudwatch:GetMetricStatistics",
        "cloudwatch:PutMetricData",
        "cloudwatch:ListMetrics",
        "codedeploy:*",
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}
