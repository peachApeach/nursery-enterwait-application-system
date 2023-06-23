const axios = require('axios');

const handler = async (event) => {
  for (const record of event.Records) {
    const keys = JSON.parse(record.body).detail.dynamodb.Keys;
    const newImage = JSON.parse(record.body).detail.dynamodb.NewImage;

    const params = {
      'request_id': keys.request_id.S,
      'request_status': newImage.request_status.N,
      'child_id': newImage.child_id.S,
      'child_name': newImage.child_name.S,
      'child_birthday': newImage.child_birthday.S,
      'user_id': newImage.user_id.S,
      'parent_name': newImage.parent_name.S,
      'parent_tel': newImage.parent_tel.S,
      'parent_address': newImage.parent_address.S,
      'parent_postcode': newImage.parent_postcode.S,
      'parent_email': newImage.parent_email.S,
      'nursery_id': newImage.nursery_id.S,
      'create_date': keys.create_date.S
    }

    try {
      const url = params.request_status === '2' ? process.env.ACCEPT_URL : process.env.REJECT_URL;
      const res = await axios.post(url, params);
      console.log(res);
    } catch (err) {
      console.log(err);
    }
  }
};

module.exports = { handler };
