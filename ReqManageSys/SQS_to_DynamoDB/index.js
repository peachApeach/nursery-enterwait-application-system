const { DynamoDBClient, PutItemCommand } = require('@aws-sdk/client-dynamodb');

const handler = async(event) => {
  const client = new DynamoDBClient({ region: 'ap-northeast-2' });

  for (const record of event.Records) {
    const recBody = JSON.parse(record.body);
    const input = {
      TableName: process.env.TABLE_NAME,
      Item: {
        child_id: { N: recBody.child_id },
        child_name: { S: recBody.child_name },
        child_birthday: { S: recBody.child_birthday },
        user_id: { S: recBody.user_id },
        parent_name: { S: recBody.parent_name },
        parent_tel: { S: recBody.parent_tel },
        parent_address: { S: recBody.parent_address },
        parent_postcode: { S: recBody.parent_postcode },
        parent_email: { S: recBody.parent_email },
        nursery_id: { S: recBody.nursery_id },
        status: { N: recBody.status },
        create_date: { S: recBody.create_date }
      },
      ConditionExpression: "attribute_not_exists(child_id) AND attribute_not_exists(nursery_id)"
    };

    try {
      const res = await client.send(new PutItemCommand(input));
      console.log(res);
    } catch (err) {
      console.log('아동의 해당 어린이집 입소대기 신청이 중복되어 실패');
      console.log(err);
    }
  }
};

module.exports = { handler };