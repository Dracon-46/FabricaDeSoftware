// filepath: c:\Users\Arthur\FabricaDeSoftware\index.js
const express = require('express');
const path = require('path');
const pool = require('./db'); // importa a conexão

const app = express();

app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, 'views'));

// Teste de conexão na rota principal
app.get('/', async (req, res) => {
  try {
    const result = await pool.query('SELECT NOW()');
    res.render('index', { dbTime: result.rows[0].now });
  } catch (err) {
    res.status(500).send('Erro ao conectar ao banco de dados: ' + err.message);
  }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Servidor rodando em http://localhost:${PORT}`);
});