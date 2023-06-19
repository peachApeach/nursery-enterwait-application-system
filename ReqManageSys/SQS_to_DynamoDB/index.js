const { DynamoDBClient, PutItemCommand } = require('@aws-sdk/client-dynamodb');
const { DynamoDBDocumentClient, ExecuteStatementCommand } = require('@aws-sdk/lib-dynamodb');

const handler = async(event) => {
  const client = new DynamoDBClient({ region: 'ap-northeast-2' });
  const docClient = DynamoDBDocumentClient.from(client);

  for (const record of event.Records) {
    const reqBody = JSON.parse(record.body);
    const reqStatus = record.messageAttributes.Status.stringValue;
    const request_id = reqBody.child_id + reqBody.nursery_id;
    
    const command = new ExecuteStatementCommand({
      Statement: `SELECT * FROM request4 WHERE request_id = '${request_id}' ORDER BY create_date DESC`,
      Parameters: [false],
      ConsistentRead: false
    });
    
    let lastStatus= '';
    try {
      const res = await docClient.send(command);
      lastStatus = res.Items[0].request_status;
      
      console.log(res);
    } catch (err) {
      lastStatus = '';
      
      console.log(err);
    }
  
    const input = {
      TableName: process.env.TABLE_NAME,
      Item: {
        request_id: {
          S: request_id
        },
        request_status: {
          N: reqBody.request_status
        },
        child_id: { 
          N: reqBody.child_id 
        },
        child_name: { 
          S: reqBody.child_name
        },
        child_birthday: { 
          S: reqBody.child_birthday
        },
        user_id: { 
          S: reqBody.user_id
        },
        parent_name: { 
          S: reqBody.parent_name
        },
        parent_tel: { 
          S: reqBody.parent_tel
        },
        parent_address: {
          S: reqBody.parent_address
        },
        parent_postcode: { 
            S: reqBody.parent_postcode
        },
        parent_email: { 
          S: reqBody.parent_email
        },
        nursery_id: { 
          S: reqBody.nursery_id
        },
        create_date: { 
          S: reqBody.create_date
        }
      },
    };

    console.log(input);
    
    //1 : 신청, 99 : 취소, 2 : 승인, 88: 반려
    if ((reqStatus === 'Request' && lastStatus !== 1) || (reqStatus !== 'Request' && lastStatus === 1)) {
      try {
        const res = await client.send(new PutItemCommand(input));
        console.log(res);
      } catch (err) {
        console.log(err);
      }
    } else {
      console.log('조건에 맞지 않아 실행되지 아니한다.');
    }
  }
};

module.exports = { handler };