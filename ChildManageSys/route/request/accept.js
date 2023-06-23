const router = require('express').Router();
const { connection, queries: { selectRequest, updateRequest, insertChild } } = require('../../module/mysql');
const { sqsClient, sqsParams } = require('../../module/sqs');
const { SendMessageCommand } = require('@aws-sdk/client-sqs');

router.post('/', connection, async (req, res) => {
  const setParams = sqsParams(req.body, 'Accept');

  try {
    //request 테이블에 데이터가 있는지 먼저 Select
    const [ selectRows ] = await req.connection.query(selectRequest(JSON.parse(setParams.MessageBody)));
    if (selectRows.length === 0) throw new Error('기존 request 데이터가 없습니다.');

    //request 테이블에 데이터를 Update
    const [ updateRows ] = await req.connection.query(updateRequest(JSON.parse(setParams.MessageBody)));
    console.log(updateRows);

    //nursery_child 테이블에 데이터를 Insert
    const [ insertRows ] = await req.connection.query(insertChild(JSON.parse(setParams.MessageBody)));
    console.log(insertRows);

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
