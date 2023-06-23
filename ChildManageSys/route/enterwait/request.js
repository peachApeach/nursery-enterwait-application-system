const router = require('express').Router();
const { connection, queries: { insertRequest } } = require('../../module/mysql');

router.post('/', connection, async (req, res) => {
  try {
    const [ insertResult ] = await req.connection.query(insertRequest(req.body));
    console.log(insertResult);
    res.send('Success!');
  } catch (err) {
    console.log(err);
    res.send(err);
  }
});

module.exports = router;
