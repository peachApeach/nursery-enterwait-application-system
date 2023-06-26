const mysql = require('mysql2/promise');
const moment = require('moment');

require('dotenv').config();

const connection = async (req, res, next) => {
  try {
    req.connection = await mysql.createConnection({
      host: process.env.HOSTNAME,
      user: process.env.USERNAME,
      password: process.env.PASSWORD,
      database: process.env.DATABASE
    });
    next();
  } catch (err) {
    console.log(err);
    res.status(500).send('DB Connection Error!');
  }
};

const selectRequest = (body) => `
  SELECT *
    FROM request
   WHERE request_id = '${body.request_id}'
`;

const selectRequests = (body) => `
  SELECT *
    FROM request
   WHERE 1 =1
     ${body}
`;

const insertRequest = (body) => `
  INSERT INTO request(request_id,
                      request_status,
                      child_id,
                      child_name,
                      child_birthday,
                      user_id,
                      parent_name,
                      parent_tel,
                      parent_address,
                      parent_postcode,
                      parent_email,
                      nursery_id,
                      create_date,
                      change_date)
  VALUES('${body.request_id}',
         ${body.request_status},
         '${body.child_id}',
         '${body.child_name}',
         '${body.child_birthday}',
         '${body.user_id}',
         '${body.parent_name}',
         '${body.parent_tel}',
         '${body.parent_address}',
         '${body.parent_postcode}',
         '${body.parent_email}',
         '${body.nursery_id}',
         '${moment(new Date(body.create_date)).format('YYYY-MM-DD HH:mm:ss')}',
         '${moment(new Date(body.create_date)).format('YYYY-MM-DD HH:mm:ss')}')
  ON DUPLICATE KEY
  UPDATE request_status = ${body.request_status},
         child_name = '${body.child_name}',
         child_birthday = '${body.child_birthday}',
         user_id = '${body.user_id}',
         parent_name = '${body.parent_name}',
         parent_tel = '${body.parent_tel}',
         parent_address = '${body.parent_address}',
         parent_postcode = '${body.parent_postcode}',
         parent_email = '${body.parent_email}',
         create_date = '${moment(new Date(body.create_date)).format('YYYY-MM-DD HH:mm:ss')}',
         change_date = '${moment(new Date(body.create_date)).format('YYYY-MM-DD HH:mm:ss')}'
`;

const updateRequest = (body) => `
  UPDATE request
     SET request_status = ${body.request_status},
         change_date = '${moment(new Date(body.create_date)).format('YYYY-MM-DD HH:mm:ss')}'
   WHERE request_id = '${body.request_id}'
`;

const insertChild = (body) => `
  INSERT INTO nursery_child(nursery_id,
                            child_id,
                            child_name,
                            child_birthday,
                            parent_name,
                            parent_tel,
                            parent_address,
                            parent_postcode,
                            parent_email,
                            create_date,
                            change_date)
  VALUES('${body.nursery_id}',
         '${body.child_id}',
         '${body.child_name}',
         '${body.child_birthday}',
         '${body.parent_name}',
         '${body.parent_tel}',
         '${body.parent_address}',
         '${body.parent_postcode}',
         '${body.parent_email}',
         '${moment(new Date(body.create_date)).format('YYYY-MM-DD HH:mm:ss')}',
         '${moment(new Date(body.create_date)).format('YYYY-MM-DD HH:mm:ss')}')
  ON DUPLICATE KEY
  UPDATE child_name = '${body.child_name}',
         child_birthday = '${body.child_birthday}',
         parent_name = '${body.parent_name}',
         parent_tel = '${body.parent_tel}',
         parent_address = '${body.parent_address}',
         parent_postcode = '${body.parent_postcode}',
         parent_email = '${body.parent_email}',
         create_date = '${moment(new Date(body.create_date)).format('YYYY-MM-DD HH:mm:ss')}',
         change_date = '${moment(new Date(body.create_date)).format('YYYY-MM-DD HH:mm:ss')}'
`;

const cRequest = () => `
  CREATE TABLE \`request\` (
    \`request_id\` varchar(100) NOT NULL,
    \`request_status\` int NOT NULL,
    \`child_id\` varchar(100) NOT NULL,
    \`child_name\` varchar(100) NOT NULL,
    \`child_birthday\` varchar(100) NOT NULL,
    \`user_id\` varchar(100) NOT NULL,
    \`parent_name\` varchar(100) NOT NULL,
    \`parent_tel\` varchar(100) NOT NULL,
    \`parent_address\` varchar(150) NOT NULL,
    \`parent_postcode\` varchar(5) NOT NULL,
    \`parent_email\` varchar(100) NOT NULL,
    \`nursery_id\` varchar(100) NOT NULL,
    \`create_date\` timestamp NOT NULL,
    \`change_date\` timestamp NOT NULL,

    PRIMARY KEY (
      \`request_id\`
    )
  );                                  
`;

const cNursery = () => `
  CREATE TABLE \`nursery\` (
    \`nursery_id\` varchar(100) NOT NULL,
    \`nursery_password\` varchar(100) NOT NULL,
    \`nursery_name\` varchar(100) NOT NULL,
    \`nursery_tel\` varchar(100) NOT NULL,
    \`postcode\` varchar(5) NOT NULL,
    \`address\` varchar(150) NOT NULL,
    \`email\` varchar(100) NOT NULL,
    \`capacity\` int NOT NULL,
    \`create_date\` timestamp NOT NULL,
    \`change_date\` timestamp NOT NULL,

    PRIMARY KEY (
      \`nursery_id\`
    )
  );
`;

const cNurseryChild = () => `
  CREATE TABLE \`nursery_child\` (
    \`nursery_id\` varchar(100) NOT NULL,
    \`child_id\` varchar(100) NOT NULL,
    \`child_name\` varchar(100) NOT NULL,
    \`child_birthday\` varchar(100)  NOT NULL,
    \`parent_name\` varchar(100) NOT NULL,
    \`parent_tel\` varchar(100) NOT NULL,
    \`parent_address\` varchar(150) NOT NULL,
    \`parent_postcode\` varchar(5) NOT NULL,
    \`parent_email\` varchar(100) NOT NULL,
    \`create_date\` timestamp  NOT NULL,
    \`change_date\` timestamp  NOT NULL,

    PRIMARY KEY (
      \`nursery_id\`,
      \`child_id\`
    )
  );
`;

module.exports = {
  connection,
  queries: {
    selectRequest,
    selectRequests,
    insertRequest,
    updateRequest,
    insertChild,
    cRequest,
    cNursery,
    cNurseryChild
  }
};
