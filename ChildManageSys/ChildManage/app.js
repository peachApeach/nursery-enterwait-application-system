const express = require('express');
const app = express();
const port = 4000;

require('dotenv').config();

const { SQSClient, SendMessageCommand } = require('@aws-sdk/client-sqs');

const mysql = require('mysql');
const connection = mysql.createConnection({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DATABASE
});
connection.connect();

app.use(express.json());

app.post('/request/accept', async function(req, res) {
  const sqsClient = new SQSClient({ region: 'ap-northeast-2' });

  const reqBody = req.body;
  reqBody.create_date = new Date(Date.now()).toISOString();
  reqBody.request_status = "2";

  const params = {
    QueueUrl: process.env.TOPIC_ARN,
    MessageBody: JSON.stringify(reqBody),
    MessageAttributes: {
      "Status": {
        DataType: "String",
        StringValue: "Accept"
      }
    }
  };
  
  try {
    const response = await sqsClient.send(new SendMessageCommand(params));
    console.log(response);
  } catch (err) {
    console.log(err);
    res.send('Failed!');
  }

//  connection.connect();
  connection.query(`UPDATE request
   SET request_status = 2 
   WHERE request_id = '${reqBody.child_id + reqBody.nursery_id}'`, (error, results, fields) => {
    if (error) throw error;
    console.log(results);
    console.log(fields);
  });
//  connection.end();

  res.send('Success!');
});

app.post('/request/reject', async function(req,res) {
  const sqsClient = new SQSClient({ region: 'ap-northeast-2' });

  const reqBody = req.body;
  reqBody.create_date = new Date(Date.now()).toISOString();
  reqBody.request_status = "88";

  const params = {
    QueueUrl: process.env.TOPIC_ARN,
    MessageBody: JSON.stringify(reqBody),
    MessageAttributes: {
      "Status": {
        DataType: "String",
        StringValue: "Reject"
      }
    }
  };

  try {
    const response = await sqsClient.send(new SendMessageCommand(params));
    console.log(response);
  } catch (err) {
    console.log(err);
    res.send('Failed!');
  }

//  connection.connect();
  connection.query(`UPDATE request
    SET request_status = 88
    WHERE request_id = '${reqBody.child_id + reqBody.nursery_id}'`, (error, results, fields) => {
      if (error) throw error;
      console.log(results);
      console.log(fields);
  });
//  connection.end();

  res.send('Success!');
});

app.listen(port, () => {
  console.log(`Child Management System listening on port ${port}`);
});
