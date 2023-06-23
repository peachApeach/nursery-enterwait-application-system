const express = require('express');
const app = express();
const port = 4000;

app.get('/', (req, res) => {
  res.status(200).send('Hello, World!');
});

app.use(express.json());

app.use('/admin/init', require('./route/admin/init'));

app.use('/request/accept', require('./route/request/accept'));
app.use('/request/reject', require('./route/request/reject'));

app.use('/enterwait/request', require('./route/enterwait/request'));
app.use('/enterwait/cancel', require('./route/enterwait/cancel'));

app.listen(port, () => {
  console.log(`Nursery System listening on port ${port}...`);
});
