const pool = require("../../db");

// Listar todas as relaÃ§Ãµes recurso-projeto
exports.index = async (req, res) => {
  try {
    const result = await pool.query(
      "SELECT rp.*, r.nome as recurso_nome, p.nome as projeto_nome " +
      "FROM recursos_projeto rp " +
      "INNER JOIN recursos r ON rp.recurso_id = r.id " +
      "INNER JOIN projetos p ON rp.projeto_id = p.id"
    );
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Salvar nova relaÃ§Ã£o recurso-projeto
exports.store = async (req, res) => {
  try {
    const { recurso_id, projeto_id, quantidade, data_inicio, data_fim } = req.body;
    const result = await pool.query(
      "INSERT INTO recursos_projeto (recurso_id, projeto_id, quantidade, data_inicio, data_fim) VALUES ($1, $2, $3, $4, $5) RETURNING *",
      [recurso_id, projeto_id, quantidade, data_inicio, data_fim]
    );
    res.status(201).json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Buscar relaÃ§Ã£o recurso-projeto por ID
exports.show = async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query(
      "SELECT rp.*, r.nome as recurso_nome, p.nome as projeto_nome " +
      "FROM recursos_projeto rp " +
      "INNER JOIN recursos r ON rp.recurso_id = r.id " +
      "INNER JOIN projetos p ON rp.projeto_id = p.id " +
      "WHERE rp.id = $1",
      [id]
    );
    if (result.rows.length === 0) {
      return res.status(404).json({ message: "RelaÃ§Ã£o recurso-projeto nÃ£o encontrada" });
    }
    res.json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Atualizar relaÃ§Ã£o recurso-projeto
exports.update = async (req, res) => {
  try {
    const { id } = req.params;
    const { recurso_id, projeto_id, quantidade, data_inicio, data_fim } = req.body;
    const result = await pool.query(
      "UPDATE recursos_projeto SET recurso_id=$1, projeto_id=$2, quantidade=$3, data_inicio=$4, data_fim=$5 WHERE id=$6 RETURNING *",
      [recurso_id, projeto_id, quantidade, data_inicio, data_fim, id]
    );
    if (result.rows.length === 0) {
      return res.status(404).json({ message: "RelaÃ§Ã£o recurso-projeto nÃ£o encontrada" });
    }
    res.json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Deletar relaÃ§Ã£o recurso-projeto
exports.delete = async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query("DELETE FROM recursos_projeto WHERE id = $1 RETURNING *", [id]);
    if (result.rows.length === 0) {
      return res.status(404).json({ message: "RelaÃ§Ã£o recurso-projeto nÃ£o encontrada" });
    }
    res.json({ message: "RelaÃ§Ã£o recurso-projeto deletada com sucesso" });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Listar por projeto
exports.byProjeto = async (req, res) => {
  try {
    const { projetoId } = req.params;
    const result = await pool.query(
      "SELECT rp.*, r.nome as recurso_nome " +
      "FROM recursos_projeto rp " +
      "INNER JOIN recursos r ON rp.recurso_id = r.id " +
      "WHERE rp.projeto_id = $1",
      [projetoId]
    );
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Listar por recurso
exports.byRecurso = async (req, res) => {
  try {
    const { recursoId } = req.params;
    const result = await pool.query(
      "SELECT rp.*, p.nome as projeto_nome " +
      "FROM recursos_projeto rp " +
      "INNER JOIN projetos p ON rp.projeto_id = p.id " +
      "WHERE rp.recurso_id = $1",
      [recursoId]
    );
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};
