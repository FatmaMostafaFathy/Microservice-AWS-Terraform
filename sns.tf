resource "aws_sns_topic" "sns-micro" {
  name = "sns-micro"


  policy  = <<EOF
 {
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": "SNS:Publish",
      "Resource": "arn:aws:sns:*:*:sns-s3",
      "Condition": {
        "ArnLike": {
          "aws:SourceArn": "arn:aws:s3:*:*:*"
        }
      }
    }
  ]
}
EOF
}

resource "aws_sns_topic_subscription" "sns-sub-mail" {
  topic_arn = aws_sns_topic.sns-micro.arn
  protocol = "email"
  endpoint = "fatmamostafafathy@gmail.com"
}

# resource "aws_s3_bucket_notification" "bucket_notification" {
#   bucket = aws_s3_bucket.fatmaellawindybucket.id
#   topic {
#     topic_arn     = aws_sns_topic.sns-micro.arn
#     events        = ["s3:ObjectCreated:*"]
#   }
# }
