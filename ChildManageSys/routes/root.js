'use strict'

module.exports = async function (fastify, opts) {
  fastify.get('/', async function (request, reply) {
    try {
      const mysql = fastify.mysql;
      const query = `SELECT * FROM nur_child`;
      const result = await mysql.query(query);
      console.log(result);
      reply.code(200).header('Content-type','application/json').send(result[0])
    } catch (error) {
      console.error(error);
      reply.code(400).send("목록 조회에 실패했습니다.")
    }
  })
}
