const pool = require("../../db");

// Listar todos os documentos
exports.index = async (req, res) => {
  try {
    const result = await pool.query("SELECT * FROM documentos");
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Salvar novo documento
exports.store = async (req, res) => {
  try {
    const { nome, tipo, url, projeto_id, descricao } = req.body;
    const result = await pool.query(
      "INSERT INTO documentos (nome, tipo, url, projeto_id, descricao) VALUES ($1, $2, $3, $4, $5) RETURNING *",
      [nome, tipo, url, projeto_id, descricao]
    );
    res.status(201).json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Buscar documento por ID
exports.show = async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query("SELECT * FROM documentos WHERE id = $1", [id]);
    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Documento nÃ£o encontrado" });
    }
    res.json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Atualizar documento
exports.update = async (req, res) => {
  try {
    const { id } = req.params;
    const { nome, tipo, url, projeto_id, descricao } = req.body;
    const result = await pool.query(
      "UPDATE documentos SET nome=$1, tipo=$2, url=$3, projeto_id=$4, descricao=$5 WHERE id=$6 RETURNING *",
      [nome, tipo, url, projeto_id, descricao, id]
    );
    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Documento nÃ£o encontrado" });
    }
    res.json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Deletar documento
exports.delete = async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query("DELETE FROM documentos WHERE id = $1 RETURNING *", [id]);
    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Documento nÃ£o encontrado" });
    }
    res.json({ message: "Documento deletado com sucesso" });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Listar documentos por projeto
exports.byProjeto = async (req, res) => {
  try {
    const { projetoId } = req.params;
    const result = await pool.query(
      "SELECT * FROM documentos WHERE projeto_id = $1",
      [projetoId]
    );
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};
