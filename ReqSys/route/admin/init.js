const router = require('express').Router();
const { connection, queries: { cRequest, cNursery, cChild, cUser } } = require('../../module/mysql');

router.get('/', connection, async (req, res) => {
  try {
    const [ crResult ] = await req.connection.query(cRequest());
    const [ cnResult ] = await req.connection.query(cNursery());
    const [ ccResult ] = await req.connection.query(cChild());
    const [ cuResult ] = await req.connection.query(cUser());
    res.send('DB 초기화에 성공하였습니다.');
  } catch (err) {
    console.log(err);
    res.send('DB 초기화에 실패하였씁니다.');
  }
});

module.exports = router;
