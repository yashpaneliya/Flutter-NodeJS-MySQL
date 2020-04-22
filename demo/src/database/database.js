const mysql = require('mysql');

const mysqlconnection = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: 'yash',
    database: 'demo',
});

mysqlconnection.connect(function(error) {
    if (error) {
        console.log(error);
        return;
    } else {
        console.log('database connected');
    }
});

module.exports = mysqlconnection;