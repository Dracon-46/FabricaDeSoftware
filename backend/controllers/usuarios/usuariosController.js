const pool = require("../../db");
const bcrypt = require("bcrypt");

// Listar todos os usuários
exports.index = async (req, res) => {
  try {
    const result = await pool.query("SELECT id, nome, email, nivel FROM usuarios");
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Salvar novo usuário
exports.store = async (req, res) => {
  try {
    const { nome, email, senha, nivel } = req.body;
    const hashedSenha = await bcrypt.hash(senha, 10);
    const result = await pool.query(
      "INSERT INTO usuarios (nome, email, senha, nivel) VALUES ($1, $2, $3, $4) RETURNING id, nome, email, nivel",
      [nome, email, hashedSenha, nivel]
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
    const result = await pool.query(
      "SELECT id, nome, email, nivel FROM usuarios WHERE id = $1",
      [id]
    );
    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Usuário não encontrado" });
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
    const { nome, email, senha, nivel } = req.body;

    let query;
    let params;

    if (senha) {
      const hashedSenha = await bcrypt.hash(senha, 10);
      query = "UPDATE usuarios SET nome=$1, email=$2, senha=$3, nivel=$4 WHERE id=$5 RETURNING id, nome, email, nivel";
      params = [nome, email, hashedSenha, nivel, id];
    } else {
      query = "UPDATE usuarios SET nome=$1, email=$2, nivel=$3 WHERE id=$4 RETURNING id, nome, email, nivel";
      params = [nome, email, nivel, id];
    }

    const result = await pool.query(query, params);
    
    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Usuário não encontrado" });
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
    const result = await pool.query("DELETE FROM usuarios WHERE id = $1 RETURNING *", [id]);
    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Usuário não encontrado" });
    }
    res.json({ message: "Usuário deletado com sucesso" });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};
