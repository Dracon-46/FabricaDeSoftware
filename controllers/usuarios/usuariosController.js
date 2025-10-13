const pool = require('../../db');

// Listar todos os usuários
exports.index = async (req, res) => {
  const result = await pool.query('SELECT * FROM usuarios');
  res.render('usuarios/index', { usuarios: result.rows });
};

// Formulário de criação
exports.create = (req, res) => {
  res.render('usuarios/create');
};

// Salvar novo usuário
exports.store = async (req, res) => {
  const { nome, email, senha, nivel, telefone } = req.body;
  await pool.query(
    'INSERT INTO usuarios (nome, email, senha, nivel, telefone) VALUES ($1, $2, $3, $4, $5)',
    [nome, email, senha, nivel, telefone]
  );
  res.redirect('/usuarios');
};

// Formulário de edição
exports.edit = async (req, res) => {
  const { id } = req.params;
  const result = await pool.query('SELECT * FROM usuarios WHERE id = $1', [id]);
  res.render('usuarios/edit', { usuario: result.rows[0] });
};

// Atualizar usuário
exports.update = async (req, res) => {
  const { id } = req.params;
  const { nome, email, senha, nivel, telefone } = req.body;
  await pool.query(
    'UPDATE usuarios SET nome=$1, email=$2, senha=$3, nivel=$4, telefone=$5 WHERE id=$6',
    [nome, email, senha, nivel, telefone, id]
  );
  res.redirect('/usuarios');
};

// Deletar usuário
exports.delete = async (req, res) => {
  const { id } = req.params;
  await pool.query('DELETE FROM usuarios WHERE id = $1', [id]);
  res.redirect('/usuarios');
};
