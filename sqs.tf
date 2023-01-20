resource "aws_sqs_queue" "queue1" {
  name = "firstqueue"
  visibility_timeout_seconds = 15  
    redrive_policy    = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dead_letter_queue.arn
    maxReceiveCount    = 5
  })
}

resource "aws_sqs_queue" "queue2" {
  name = "secondqueue"
  visibility_timeout_seconds = 15
    redrive_policy    = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dead_letter_queue.arn
    maxReceiveCount    = 5
  })

}

resource "aws_sqs_queue" "dead_letter_queue" {
  name              = "dead-letter-queue"
  visibility_timeout_seconds = 200
}

resource "aws_sqs_queue_policy" "sqspolicy1" {
  queue_url = aws_sqs_queue.queue1.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "sqspolicy",
  "Statement": [
    {
      "Sid": "First",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "sqs:SendMessage",
      "Resource": "${aws_sqs_queue.queue1.arn}",
      "Condition": {
        "ArnEquals": {
          "aws:SourceArn": "${aws_sns_topic.sns-micro.arn}"
        }
      }
    }
  ]
}
POLICY
}

resource "aws_sqs_queue_policy" "sqspolicy2" {
  queue_url = aws_sqs_queue.queue2.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "sqspolicy",
  "Statement": [
    {
      "Sid": "Secound",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "sqs:SendMessage",
      "Resource": "${aws_sqs_queue.queue2.arn}",
      "Condition": {
        "ArnEquals": {
          "aws:SourceArn": "${aws_sns_topic.sns-micro.arn}"
        }
      }
    }
  ]
}
POLICY
}

resource "aws_sns_topic_subscription" "first_sqs_target" {

  topic_arn = aws_sns_topic.sns-micro.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.queue1.arn
}

resource "aws_sns_topic_subscription" "secound_sqs_target" {

  topic_arn = aws_sns_topic.sns-micro.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.queue2.arn
}
