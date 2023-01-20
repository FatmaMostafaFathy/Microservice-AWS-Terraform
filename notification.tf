
resource "aws_s3_bucket_notification" "Notification" {
  bucket = aws_s3_bucket.fatmaellawindybuckett.id
  topic {
    topic_arn = aws_sns_topic.sns-micro.arn
    events    = ["s3:ObjectCreated:*"]
  }
}
