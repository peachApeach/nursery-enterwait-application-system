const { SQSClient, SendMessageCommand } = require('@aws-sdk/client-sqs');

const sqsClient = new SQSClient({
  region: process.env.REGION,
  credentials: {
    accessKeyId: process.env.AWS_ACCESS_KEY_ID,
    secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY
  }
});

const sqsParams = (body, msgAttrStatus) => {
  body.request_id = body.child_id + body.nursery_id
  body.request_status = msgAttrStatus === 'Accept' ? '2' : '88';
  body.create_date = new Date(Date.now()).toISOString();

  return {
    QueueUrl: process.env.QUEUE_URL,
    MessageBody: JSON.stringify(body),
    MessageAttributes: {
      'Status': {
        DataType: 'String',
        StringValue: msgAttrStatus
      }
    }
  };
};

module.exports = {
  sqsClient,
  sqsParams
};
