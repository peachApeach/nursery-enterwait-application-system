const fp = require('fastify-plugin')

const { HOSTNAME, USERNAME, PASSWORD, PORT, SERVERNAME } = process.env

module.exports = fp(async function (fastify, opts) {
  const url = `mysql://${USERNAME}:${PASSWORD}@${HOSTNAME}:${PORT}/${SERVERNAME}`
  fastify.register(require('@fastify/mysql'), {
    promise: true,
    connectionString: url
})
})