const { EventBridgeClient, PutEventsCommand } = require('@aws-sdk/client-eventbridge');

const handler = async (event) => {
  const client = new EventBridgeClient({ region: 'ap-northeast-2' });

  for (const record of event.Records) {
    let request_status = '';
    switch(record.dynamodb.NewImage.request_status.N) {
      case '1':
        request_status = 'Request';
        break;
      case '2':
        request_status = 'Accept';
        break;
      case '88':
        request_status = 'Reject';
        break;
      case '99':
        request_status = 'Cancel';
        break;
    }
    
    const input = {
      Entries: [
        {
          Time: new Date(record.dynamodb.Keys.create_date.S),
          Source: 'DynamoDB',
          DetailType: request_status,
          Detail: JSON.stringify(record),
          EventBusName: 'default'
        }
      ]
    };

    try {
      const res = await client.send(new PutEventsCommand(input));
      console.log(res);
    } catch (err) {
      console.log(err);
    }
  }
};

module.exports = { handler };
