import boto3
import csv
import time
sqs = boto3.resource('sqs')
sqs2 = boto3.client('sqs')
s3 = boto3.resource('s3')
queue = sqs.get_queue_by_name(QueueName='secondqueue')

while True:

    response = sqs2.receive_message(QueueUrl=queue.url, MaxNumberOfMessages=10,WaitTimeSeconds=20)
    try:

        messages = response['Messages']
        message = messages[0]
        receipt_handle = message['ReceiptHandle']

        for message in messages:

            body = message['Body']

            with open('metadata.csv', mode='w', newline='') as csvfile:

                writer = csv.writer(csvfile)

                writer.writerow([body])
                
            time.sleep(500)
            sqs2.delete_message(QueueUrl=queue.url, ReceiptHandle=receipt_handle)
            print(body)
            print ("messages from the sqs queue and store successfully")

    except KeyError:  

        pass