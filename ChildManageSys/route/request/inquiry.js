const router = require('express').Router();
const { connection, queries: { selectRequests } } = require('../../module/mysql');

router.get('/', connection, async (req, res) => {
  let query = '';
  if(req.query.nursery_id) query += `AND nursery_id = '${req.query.nursery_id}'`;
  else {
    res.status(400).send('필수 항목이 누락되었습니다.');
    return -1;
  }

  if(req.query.child_id) query += `AND child_id = '${req.query.child_id}'`;
  
  try {
    const [ results ] = await req.connection.query(selectRequests(query));
    console.log(results);
    res.status(200).send(results);
  } catch (err) {
    console.log(err);
    res.send('Failed!');
  }
});

module.exports = router;
