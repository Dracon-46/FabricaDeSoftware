const pool = require("../../db");
const bcrypt = require("bcrypt");

// Listar todos os usuÃ¡rios
exports.index = async (req, res) => {
  try {
    const result = await pool.query("SELECT id, nome, email, cargo FROM usuarios");
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Salvar novo usuÃ¡rio
exports.store = async (req, res) => {
  try {
    const { nome, email, senha, cargo } = req.body;
    const hashedSenha = await bcrypt.hash(senha, 10);
    const result = await pool.query(
      "INSERT INTO usuarios (nome, email, senha, cargo) VALUES ($1, $2, $3, $4) RETURNING id, nome, email, cargo",
      [nome, email, hashedSenha, cargo]
    );
    res.status(201).json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Buscar usuÃ¡rio por ID
exports.show = async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query(
      "SELECT id, nome, email, cargo FROM usuarios WHERE id = $1",
      [id]
    );
    if (result.rows.length === 0) {
      return res.status(404).json({ message: "UsuÃ¡rio nÃ£o encontrado" });
    }
    res.json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Atualizar usuÃ¡rio
exports.update = async (req, res) => {
  try {
    const { id } = req.params;
    const { nome, email, senha, cargo } = req.body;

    let query;
    let params;

    if (senha) {
      const hashedSenha = await bcrypt.hash(senha, 10);
      query = "UPDATE usuarios SET nome=$1, email=$2, senha=$3, cargo=$4 WHERE id=$5 RETURNING id, nome, email, cargo";
      params = [nome, email, hashedSenha, cargo, id];
    } else {
      query = "UPDATE usuarios SET nome=$1, email=$2, cargo=$3 WHERE id=$4 RETURNING id, nome, email, cargo";
      params = [nome, email, cargo, id];
    }

    const result = await pool.query(query, params);
    
    if (result.rows.length === 0) {
      return res.status(404).json({ message: "UsuÃ¡rio nÃ£o encontrado" });
    }
    res.json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Deletar usuÃ¡rio
exports.delete = async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query("DELETE FROM usuarios WHERE id = $1 RETURNING *", [id]);
    if (result.rows.length === 0) {
      return res.status(404).json({ message: "UsuÃ¡rio nÃ£o encontrado" });
    }
    res.json({ message: "UsuÃ¡rio deletado com sucesso" });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};
