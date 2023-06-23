const { SESClient, SendEmailCommand } = require('@aws-sdk/client-ses');

const handler = async (event) => {
  console.log(event);

  const client = new SESClient();
  const input = {
    Source: 'hongbre@gmail.com',
    Destination: {
      ToAddresses: ['hongbre@gmail.com']
    },
    Message: {
      Subject: {
        Data: event['detail-type'],
        Charset: 'UTF-8'
      },
      Body: {
        Text: {
          Data: event['detail-type'],
          Charset: 'UTF-8'
        }
      }
    }
  };
  
  const res = await client.send(new SendEmailCommand(input));
  console.log(res);
};

module.exports = { handler };
