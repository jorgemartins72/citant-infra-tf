resource "aws_sqs_queue" "worker" {
  name                        = "${var.projeto}.fifo"
  fifo_queue                  = true
  content_based_deduplication = true
  sqs_managed_sse_enabled     = false
}

resource "aws_sqs_queue_policy" "worker_policy" {
  queue_url = aws_sqs_queue.worker.id
  policy    = <<EOF
{
  "Version": "2012-10-17",
  "Id": "PolicyWorker${var.tagname}",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "sqs:*",
      "Resource": "${aws_sqs_queue.worker.arn}"
    }
  ]
}
EOF
}

output "sqs_name" {
  value = aws_sqs_queue.worker.name
}
