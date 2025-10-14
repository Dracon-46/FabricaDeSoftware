const pool = require("../../db");

// Listar todos os requisitos
exports.index = async (req, res) => {
  try {
    const result = await pool.query("SELECT * FROM requisitos");
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Salvar novo requisito
exports.store = async (req, res) => {
  try {
    const { nome, descricao, tipo, prioridade } = req.body;
    const result = await pool.query(
      "INSERT INTO requisitos (nome, descricao, tipo, prioridade) VALUES ($1, $2, $3, $4) RETURNING *",
      [nome, descricao, tipo, prioridade]
    );
    res.status(201).json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Buscar requisito por ID
exports.show = async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query("SELECT * FROM requisitos WHERE id = $1", [id]);
    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Requisito nÃ£o encontrado" });
    }
    res.json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Atualizar requisito
exports.update = async (req, res) => {
  try {
    const { id } = req.params;
    const { nome, descricao, tipo, prioridade } = req.body;
    const result = await pool.query(
      "UPDATE requisitos SET nome=$1, descricao=$2, tipo=$3, prioridade=$4 WHERE id=$5 RETURNING *",
      [nome, descricao, tipo, prioridade, id]
    );
    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Requisito nÃ£o encontrado" });
    }
    res.json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Deletar requisito
exports.delete = async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query("DELETE FROM requisitos WHERE id = $1 RETURNING *", [id]);
    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Requisito nÃ£o encontrado" });
    }
    res.json({ message: "Requisito deletado com sucesso" });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Listar projetos que tÃªm o requisito
exports.projetos = async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query(
      "SELECT p.* FROM projetos p " +
      "INNER JOIN requisitos_projeto rp ON p.id = rp.projeto_id " +
      "WHERE rp.requisito_id = $1",
      [id]
    );
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Listar por tipo
exports.byTipo = async (req, res) => {
  try {
    const { tipo } = req.params;
    const result = await pool.query(
      "SELECT * FROM requisitos WHERE tipo = $1",
      [tipo]
    );
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Listar por prioridade
exports.byPrioridade = async (req, res) => {
  try {
    const { prioridade } = req.params;
    const result = await pool.query(
      "SELECT * FROM requisitos WHERE prioridade = $1",
      [prioridade]
    );
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};
