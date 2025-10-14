const pool = require('../db');

// Listar todos os usuários
exports.index = async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM usuarios');
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};



// Salvar novo usuário
exports.store = async (req, res) => {
  try {
    const { nome, email, senha, nivel, telefone } = req.body;
    const result = await pool.query(
      'INSERT INTO usuarios (nome, email, senha, nivel, telefone) VALUES ($1, $2, $3, $4, $5) RETURNING *',
      [nome, email, senha, nivel, telefone]
    );
    res.status(201).json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Buscar usuário por ID
exports.show = async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query('SELECT * FROM usuarios WHERE id = $1', [id]);
    if (result.rows.length === 0) {
      return res.status(404).json({ message: 'Usuário não encontrado' });
    }
    res.json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Atualizar usuário
exports.update = async (req, res) => {
  try {
    const { id } = req.params;
    const { nome, email, senha, nivel, telefone } = req.body;
    const result = await pool.query(
      'UPDATE usuarios SET nome=$1, email=$2, senha=$3, nivel=$4, telefone=$5 WHERE id=$6 RETURNING *',
      [nome, email, senha, nivel, telefone, id]
    );
    if (result.rows.length === 0) {
      return res.status(404).json({ message: 'Usuário não encontrado' });
    }
    res.json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Deletar usuário
exports.delete = async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query('DELETE FROM usuarios WHERE id = $1 RETURNING *', [id]);
    if (result.rows.length === 0) {
      return res.status(404).json({ message: 'Usuário não encontrado' });
    }
    res.json({ message: 'Usuário deletado com sucesso' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};
