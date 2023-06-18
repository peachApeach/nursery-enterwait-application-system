const aws = require('aws-sdk');
const documentClient = new aws.DynamoDB.DocumentClient();

const put = async (event) => {
  for (const record of event.Records) {
    // 1. SQS Queue 가져오기 
    console.log(record);
    console.log("---")
    console.log("Message Body: ", record.body);

    // 2. dynamoDB 저장
    let parms = {
      TableName : "nur_request",
      Item : JSON.parse(record.body)
    }
      
    try {
      let data = await documentClient.put(parms).promise()
      console.log(data);

      // 3. dynamoDB 조회
      let parms1 = {
        TableName : "nur_request"
      }
      //// 조건으로 조회하기
      // let parms = {
      //   TableName: "nur_request",
      //   FilterExpression: "user_id = :user_id and child_id = :child_id",
      //   ExpressionAttributeValues : {
      //     ":user_id" : "user_01",
      //     ":child_id" : "1"
      //   }
      // }

      console.log("---")

      let result = await documentClient.scan(parms1).promise();
      console.log(result)
    }
    catch (e){
      console.log(e);
      return e;
    }
  } 
};

module.exports = {
  put,
};
