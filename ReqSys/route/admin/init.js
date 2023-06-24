const router = require('express').Router();
const { connection, queries: { cRequest, cNursery, cChild, cUser } } = require('../../module/mysql');

router.get('/', connection, async (req, res) => {
  try {
    const [ crResult ] = await connection.query(cRequest());
    const [ cnResult ] = await connection.query(cNursery());
    const [ ccResult ] = await connection.query(cChild());
    const [ cuResult ] = await connection.query(cUser());
    res.send('DB 초기화에 성공하였습니다.');
  } catch (err) {
    console.log(err);
    res.send('DB 초기화에 실패하였습니다.');
  }
});

module.exports = router;
