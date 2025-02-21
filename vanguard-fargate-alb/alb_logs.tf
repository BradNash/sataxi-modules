data "aws_iam_policy_document" "Eaccess_logs_s3_full_access" {
  statement {
    effect = "Allow"

    principals {
      identifiers = ["arn:aws:iam::098369216593:root"]
      type        = "AWS"
    }
    actions = [
      "s3:PutObject",
    ]

    resources = [
      "arn:aws:s3:::${var.lb_name}-access-logs-${var.environment}/${var.lb_name}/AWSLogs/${var.aws_account_id}/*"

    ]
  }
}

resource "aws_s3_bucket" "alb_logs" {
  bucket = "${var.lb_name}-access-logs-${var.environment}"
  acl    = var.bucket_acl

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowELBRootAccount",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::098369216593:root"
      },
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::${var.lb_name}-access-logs-${var.environment}/${var.lb_name}/*"
    },
    {
      "Sid": "AWSLogDeliveryWrite",
      "Effect": "Allow",
      "Principal": {
        "Service": "delivery.logs.amazonaws.com"
      },
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::${var.lb_name}-access-logs-${var.environment}/${var.lb_name}/*",
      "Condition": {
        "StringEquals": {
          "s3:x-amz-acl": "bucket-owner-full-control"
        }
      }
    },
    {
      "Sid": "AWSLogDeliveryAclCheck",
      "Effect": "Allow",
      "Principal": {
        "Service": "delivery.logs.amazonaws.com"
      },
      "Action": "s3:GetBucketAcl",
      "Resource": "arn:aws:s3:::${var.lb_name}-access-logs-${var.environment}"
    }
  ]
}

POLICY

  tags = {
    Name = "${var.lb_name}-${var.environment}"
  }
}

