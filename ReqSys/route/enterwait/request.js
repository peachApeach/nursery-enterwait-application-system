const router = require('express').Router();
const { connection, queries: { insertRequest } } = require('../../module/mysql');
const { sqsClient, sqsParams } = require('../../module/sqs');
const { SendMessageCommand } = require('@aws-sdk/client-sqs');

router.post('/', connection, async (req, res) => {
  const setParams = sqsParams(req.body, 'Request');
  
  try {
    //request 테이블에 데이터를 먼저 Insert
    const [ rows ] = await req.connection.query(insertRequest(JSON.parse(setParams.MessageBody)));
    console.log(rows);
    
    //SQS Queue에 메시지 전송
    const result = await sqsClient.send(new SendMessageCommand(setParams));
    console.log(result);

    res.send('Success!');
  } catch (err) {
    console.log(err);
    res.send(err);
  }
});

module.exports = router;
