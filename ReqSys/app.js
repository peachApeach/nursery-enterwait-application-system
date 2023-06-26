const express = require('express');
const app = express();
const port = 3000;

app.get('/', (req, res) => {
  res.status(200).send('Hello, World!');
});

app.use(express.json());

app.use('/admin/init', require('./route/admin/init'));

app.use('/enterwait', require('./route/enterwait/inquiry'));
app.use('/enterwait/request', require('./route/enterwait/request'));
app.use('/enterwait/cancel', require('./route/enterwait/cancel'));

app.use('/request/accept', require('./route/request/accept'));
app.use('/request/reject', require('./route/request/reject'));

app.listen(port, () => {
  console.log(`Enterwait Request System listening on port ${port}...`);
});
