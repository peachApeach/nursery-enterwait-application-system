const router = require('express').Router();
const { connection, queries: { selectRequest, updateRequest } } = require('../../module/mysql');

router.post('/', connection, async (req, res) => {
  try {
    const [ selectRow ] = await req.connection.query(selectRequest(req.body));
    if (selectRow.length === 0) throw new Error('기존 request 데이터가 없습니다.');

    const [ updateResult ] = await req.connection.query(updateRequest(req.body));
    console.log(updateResult);

    res.send('Success!');
  } catch (err) {
    console.log(err);
    res.send(err);
  }
});

module.exports = router;
