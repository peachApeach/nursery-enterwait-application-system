const router = require('express').Router();
const { connection, queries: { cRequest, cNursery, cNurseryChild } } = require('../../module/mysql');

router.get('/', connection, async (req, res) => {
  try {
    const [ crResult ] = await req.connection.query(cRequest());
    const [ cnResult ] = await req.connection.query(cNursery());
    const [ cncResult ] = await req.connection.query(cNurseryChild());
    res.send('DB 초기화에 성공하였습니다.')
  } catch (err) {
    console.log(err);
    res.send('DB 초기화에 실패하였습니다.')
  }
});

module.exports = router;
