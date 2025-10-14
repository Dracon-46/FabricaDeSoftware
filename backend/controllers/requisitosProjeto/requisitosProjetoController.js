const pool = require("../../db");

// Listar todas as relaÃ§Ãµes requisito-projeto
exports.index = async (req, res) => {
  try {
    const result = await pool.query(
      "SELECT rp.*, r.nome as requisito_nome, p.nome as projeto_nome " +
      "FROM requisitos_projeto rp " +
      "INNER JOIN requisitos r ON rp.requisito_id = r.id " +
      "INNER JOIN projetos p ON rp.projeto_id = p.id"
    );
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Salvar nova relaÃ§Ã£o requisito-projeto
exports.store = async (req, res) => {
  try {
    const { requisito_id, projeto_id, status, data_inicio, data_fim } = req.body;
    const result = await pool.query(
      "INSERT INTO requisitos_projeto (requisito_id, projeto_id, status, data_inicio, data_fim) VALUES ($1, $2, $3, $4, $5) RETURNING *",
      [requisito_id, projeto_id, status, data_inicio, data_fim]
    );
    res.status(201).json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Buscar relaÃ§Ã£o requisito-projeto por ID
exports.show = async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query(
      "SELECT rp.*, r.nome as requisito_nome, p.nome as projeto_nome " +
      "FROM requisitos_projeto rp " +
      "INNER JOIN requisitos r ON rp.requisito_id = r.id " +
      "INNER JOIN projetos p ON rp.projeto_id = p.id " +
      "WHERE rp.id = $1",
      [id]
    );
    if (result.rows.length === 0) {
      return res.status(404).json({ message: "RelaÃ§Ã£o requisito-projeto nÃ£o encontrada" });
    }
    res.json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Atualizar relaÃ§Ã£o requisito-projeto
exports.update = async (req, res) => {
  try {
    const { id } = req.params;
    const { requisito_id, projeto_id, status, data_inicio, data_fim } = req.body;
    const result = await pool.query(
      "UPDATE requisitos_projeto SET requisito_id=$1, projeto_id=$2, status=$3, data_inicio=$4, data_fim=$5 WHERE id=$6 RETURNING *",
      [requisito_id, projeto_id, status, data_inicio, data_fim, id]
    );
    if (result.rows.length === 0) {
      return res.status(404).json({ message: "RelaÃ§Ã£o requisito-projeto nÃ£o encontrada" });
    }
    res.json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Deletar relaÃ§Ã£o requisito-projeto
exports.delete = async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query("DELETE FROM requisitos_projeto WHERE id = $1 RETURNING *", [id]);
    if (result.rows.length === 0) {
      return res.status(404).json({ message: "RelaÃ§Ã£o requisito-projeto nÃ£o encontrada" });
    }
    res.json({ message: "RelaÃ§Ã£o requisito-projeto deletada com sucesso" });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Listar por projeto
exports.byProjeto = async (req, res) => {
  try {
    const { projetoId } = req.params;
    const result = await pool.query(
      "SELECT rp.*, r.nome as requisito_nome " +
      "FROM requisitos_projeto rp " +
      "INNER JOIN requisitos r ON rp.requisito_id = r.id " +
      "WHERE rp.projeto_id = $1",
      [projetoId]
    );
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Listar por requisito
exports.byRequisito = async (req, res) => {
  try {
    const { requisitoId } = req.params;
    const result = await pool.query(
      "SELECT rp.*, p.nome as projeto_nome " +
      "FROM requisitos_projeto rp " +
      "INNER JOIN projetos p ON rp.projeto_id = p.id " +
      "WHERE rp.requisito_id = $1",
      [requisitoId]
    );
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Listar por status
exports.byStatus = async (req, res) => {
  try {
    const { status } = req.params;
    const result = await pool.query(
      "SELECT rp.*, r.nome as requisito_nome, p.nome as projeto_nome " +
      "FROM requisitos_projeto rp " +
      "INNER JOIN requisitos r ON rp.requisito_id = r.id " +
      "INNER JOIN projetos p ON rp.projeto_id = p.id " +
      "WHERE rp.status = $1",
      [status]
    );
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};
