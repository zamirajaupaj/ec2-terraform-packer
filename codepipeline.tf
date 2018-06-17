resource "aws_iam_role" "RolePipeline" {
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "policyPipeline" {
  name = "policyPipeline"
  role = "${aws_iam_role.RolePipeline.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect":"Allow",
      "Action": [
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:GetBucketVersioning"
      ],
      "Resource": [
        "arn:aws:s3:::bucket-zamira",
        "arn:aws:s3:::bucket-zamira/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "codedeploy:*",
        "sns:*",
        "s3:*"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_codepipeline" "CodePipeline" {
  depends_on = ["aws_codedeploy_app.myapp", "aws_sns_topic.snsTopic"]
  name       = "pipeline"
  role_arn   = "${aws_iam_role.RolePipeline.arn}"

  artifact_store {
    location = "codepipeline-eu-west-1-909980132326"
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name     = "Source"
      category = "Source"
      owner    = "AWS"
      provider = "S3"
      version  = "1"

      output_artifacts = ["MyApp"]

      configuration {
        S3Bucket             = "bucket-zamira"
        PollForSourceChanges = true
        S3ObjectKey          = "deploy.zip"
      }
    }
  }

  stage {
    name = "Approval"

    action {
      #input_artifacts  = ["MyApp"]
      name     = "Approval"
      category = "Approval"
      owner    = "AWS"
      version  = 1
      provider = "Manual"

      #output_artifacts = ["MyApp"]

      configuration {
        NotificationArn = "${aws_sns_topic.snsTopic.arn}"
      }
    }
  }

  #"arn:aws:sns:eu-west-1:659072926143:prova"
  stage {
    name = "Deploy"

    action {
      input_artifacts = ["MyApp"]
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CodeDeploy"
      version         = "1"

      configuration {
        ApplicationName     = "myapp"
        DeploymentGroupName = "prod"
      }
    }
  }
}
