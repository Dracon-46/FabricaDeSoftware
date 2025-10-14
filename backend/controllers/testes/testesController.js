const pool = require("../../db");

// Listar todos os testes
exports.index = async (req, res) => {
  try {
    const result = await pool.query("SELECT * FROM testes");
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Salvar novo teste
exports.store = async (req, res) => {
  try {
    const { nome, descricao, tipo, status, projeto_id, data_inicio, data_fim } = req.body;
    const result = await pool.query(
      "INSERT INTO testes (nome, descricao, tipo, status, projeto_id, data_inicio, data_fim) VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING *",
      [nome, descricao, tipo, status, projeto_id, data_inicio, data_fim]
    );
    res.status(201).json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Buscar teste por ID
exports.show = async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query("SELECT * FROM testes WHERE id = $1", [id]);
    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Teste nÃ£o encontrado" });
    }
    res.json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Atualizar teste
exports.update = async (req, res) => {
  try {
    const { id } = req.params;
    const { nome, descricao, tipo, status, projeto_id, data_inicio, data_fim } = req.body;
    const result = await pool.query(
      "UPDATE testes SET nome=$1, descricao=$2, tipo=$3, status=$4, projeto_id=$5, data_inicio=$6, data_fim=$7 WHERE id=$8 RETURNING *",
      [nome, descricao, tipo, status, projeto_id, data_inicio, data_fim, id]
    );
    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Teste nÃ£o encontrado" });
    }
    res.json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Deletar teste
exports.delete = async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query("DELETE FROM testes WHERE id = $1 RETURNING *", [id]);
    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Teste nÃ£o encontrado" });
    }
    res.json({ message: "Teste deletado com sucesso" });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Listar testes por projeto
exports.byProjeto = async (req, res) => {
  try {
    const { projeto_id } = req.params;
    const result = await pool.query(
      "SELECT * FROM testes WHERE projeto_id = $1",
      [projeto_id]
    );
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Listar testes por status
exports.byStatus = async (req, res) => {
  try {
    const { status } = req.params;
    const result = await pool.query(
      "SELECT * FROM testes WHERE status = $1",
      [status]
    );
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};
