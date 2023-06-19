const express = require('express');
const app = express();
const port = 3000;

require('dotenv').config();

const { SQSClient, SendMessageCommand } = require('@aws-sdk/client-sqs');

app.use(express.json());

app.get('/', function(req, res) {
  res.send('hello world');
});

app.post('/enterwait/request', async function(req, res) {

  const sqsClient = new SQSClient({ region: 'ap-northeast-2' });

  const reqBody = req.body;
  reqBody.create_date = new Date(Date.now()).toISOString();
  reqBody.status = "1";

  const params = {
    QueueUrl: process.env.TOPIC_ARN,
    MessageBody: JSON.stringify(reqBody),
    MessageAttributes: {
      "Status": {
        DataType: "String",
        StringValue: "Request"
      }
    }
  };
  
  try {
    const data = await sqsClient.send(new SendMessageCommand(params));
    console.log(data);
  } catch (err) {
    console.log(err);
  }

  const body = req.body;
  res.send(body);
});

app.listen(port, () => {
  console.log(`Enterwait Request System listening on port ${port}`);
});
