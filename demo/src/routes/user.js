const { Router } = require('express');
const router = Router();

const mysqlconnection = require('../database/database');

router.get('/', (req, res) => {
    res.status(200).json('server on port 8000 and database is connected');
});

//get all users
router.get('/:users', (req, res) => {
    mysqlconnection.query('select * from users;', (error, rows, fields) => {
        if (!error) {
            res.json(rows);
        } else {
            console.log(error);
        }
    });
});

//get all assigned task of a user
router.get('/:users/:id/asstasks', (req, res) => {
    const { id } = req.params;
    mysqlconnection.query('select * from asstasks where id=?;', [id], (error, rows, fields) => {
        if (!error) {
            res.json(rows);
        } else {
            console.log(error);
        }
    });
});

//get all self tasks of a user
router.get('/:users/:id/selftasks', (req, res) => {
    const { id } = req.params;
    mysqlconnection.query('select * from selftask where uid=?;', [id], (error, rows, fields) => {
        if (!error) {
            res.json(rows);
        } else {
            console.log(error);
        }
    });
});

//get all numbers
router.get("/users/number", (req, res) => {
    mysqlconnection.query('select number from users;', (error, rows, fields) => {
        if (!error) {
            res.json(rows);
        } else {
            console.log(error);
        }
    });
});

//get all names
router.get("/users/names", (req, res) => {
    mysqlconnection.query('select username from users;', (error, rows, fields) => {
        if (!error) {
            res.json(rows);
        } else {
            console.log(error);
        }
    });
});

//get all email
router.get("/users/mails", (req, res) => {
    mysqlconnection.query('select email from users;', (error, rows, fields) => {
        if (!error) {
            res.json(rows);
        } else {
            console.log(error);
        }
    });
});

//get a user
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

//input new user
router.post('/:users', (req, res) => {
    const { id, username, lastname, mail, number } = req.body;
    console.log(req.body);
    mysqlconnection.query('insert into users values (?,?,?,?,?)', [id, username, lastname, mail, number], (error, rows, fields) => {
        if (!error) {
            res.json({ Status: 'user saved' });
        } else {
            console.log(error);
        }
    });
});

//update user
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

//assign task to self
router.put('/:users/:id/assignselftask', (req, res) => {
    const { id, title, desc, date, status } = req.body;
    console.log(req.body);
    mysqlconnection.query('insert into selftask values (?,?,?,?,?);', [id, title, desc, date, status], (error, rows, fields) => {
        if (!error) {
            res.json({ Status: 'selftask added' });
        } else {
            console.log(error);
        }
    });
});

//assigning task to other
router.put('/:users/:id/assigntask/:tid', (req, res) => {
    const { id, title, desc, date, tid, status } = req.body;
    console.log(req.body);
    mysqlconnection.query('insert into asstasks values (?,?,?,?,?,?);', [id, title, desc, date, tid, status], (error, rows, fields) => {
        if (!error) {
            res.json({ Status: 'task added' });
        } else {
            console.log(error);
        }
    });
});

//delete user
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