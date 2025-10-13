// filepath: c:\Users\Arthur\FabricaDeSoftware\db.js
const { Pool } = require('pg');

const pool = new Pool({
  user: 'postgres',       // substitua pelo seu usuário do PostgreSQL
  host: 'localhost',         // ou o endereço do seu servidor PostgreSQL
  database: 'bd',     // substitua pelo nome do seu banco de dados
  password: '123',     // substitua pela sua senha
  port: 5432,                // porta padrão do PostgreSQL
});

module.exports = pool;