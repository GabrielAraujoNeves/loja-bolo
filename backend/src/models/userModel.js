const pool = require('../config/db');

const createUser = async (email, password, username ) => {
    const query = 'INSERT INTO users (email, password, username) VALUES ($1, $2, $3) RETURNING id, email, username';
    const values = [email, password, username];
    const { rows } = await pool.query(query, values);
    return rows[0];
};

const findUserByEmail = async (email) => {
    const query ='SELECT * FROM users WHERE email = $1';
    const { rows } = await pool.query(query, [email]);
    return rows[0];
};

const getAllUsers = async () => {
    const query = 'SELECT id, email, username FROM users';
    const { rows } = await pool.query(query);
    return rows;
};

module.exports = { createUser, findUserByEmail, getAllUsers};