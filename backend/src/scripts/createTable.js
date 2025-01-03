const pool = require('../config/db');  // Verifique se o caminho para o arquivo db.js está correto.

const createTables = async () => {
    try {
        const createUsersTableQuery = `
            CREATE TABLE IF NOT EXISTS users (
                id SERIAL PRIMARY KEY,
                username VARCHAR(255) NOT NULL,
                email VARCHAR(255) UNIQUE NOT NULL,
                password VARCHAR(255) NOT NULL,
                created_at TIMESTAMP DEFAULT NOW(),
                updated_at TIMESTAMP DEFAULT NOW()
            );
        `;

        await pool.query(createUsersTableQuery);
        console.log('Tabela "users" criada ou já existente');
    } catch (error) {
        console.error('Erro ao criar as tabelas:', error);
    } finally {
        pool.end();
    }
};

createTables();
