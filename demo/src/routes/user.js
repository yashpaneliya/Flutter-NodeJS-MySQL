const { Router } = require('express');
const router = Router();

const mysqlconnection = require('../database/database');

router.get('/', (req, res) => {
    res.status(200).json('server on port 8000 and database is connected');
});

router.get('/:users', (req, res) => {
    mysqlconnection.query('select * from users;', (error, rows, fields) => {
        if (!error) {
            res.json(rows);
        } else {
            console.log(error);
        }
    });
});

router.get("/users/number", (req, res) => {
    mysqlconnection.query('select id,number from users;', (error, rows, fields) => {
        if (!error) {
            res.json(rows);
        } else {
            console.log(error);
        }
    });
});

router.get("/users/names", (req, res) => {
    mysqlconnection.query('select username from users;', (error, rows, fields) => {
        if (!error) {
            res.json(rows);
        } else {
            console.log(error);
        }
    });
});

router.get("/users/mails", (req, res) => {
    mysqlconnection.query('select email from users;', (error, rows, fields) => {
        if (!error) {
            res.json(rows);
        } else {
            console.log(error);
        }
    });
});

router.get('/:users/:id', (req, res) => {
    const { id } = req.params;
    mysqlconnection.query('select * from users where id = ?;', [id], (error, rows, fields) => {
        if (!error) {
            res.json(rows);
        } else {
            console.log(error);
        }
    });
});


router.post('/:users', (req, res) => {
    const { id, username, lastname, mail, number } = req.body;
    console.log(req.body);
    mysqlconnection.query('insert into users (id,username,lastname,email,number) values (?,?,?,?,?)', [id, username, lastname, mail, number], (error, rows, fields) => {
        if (!error) {
            res.json({ Status: 'user saved' });
        } else {
            console.log(error);
        }
    });
});

router.put('/:users/:id', (req, res) => {
    const { id, username, lastname, mail, number } = req.body;
    console.log(req.body);
    mysqlconnection.query('update set username=?,lastname=?,email=?,number=? where id=?', [username, lastname, mail, number, id], (error, rows, fields) => {
        if (!error) {
            res.json({ Status: 'user updated' });
        } else {
            console.log(error);
        }
    });
});

router.delete('/:users/:id', (req, res) => {
    const { id } = req.params;
    mysqlconnection.query('delete from users where id=?', [id], (error, rows, fields) => {
        if (!error) {
            res.json({ Status: 'user deleted' });
        } else {
            console.log(error);
        }
    });
});

module.exports = router;