const pool = require("../../db");

// Listar todas as relaÃ§Ãµes contribuidor-projeto
exports.index = async (req, res) => {
  try {
    const result = await pool.query(
      "SELECT cp.*, c.nome as contribuidor_nome, p.nome as projeto_nome " +
      "FROM contribuidores_projeto cp " +
      "INNER JOIN contribuidores c ON cp.contribuidor_id = c.id " +
      "INNER JOIN projetos p ON cp.projeto_id = p.id"
    );
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Salvar nova relaÃ§Ã£o contribuidor-projeto
exports.store = async (req, res) => {
  try {
    const { contribuidor_id, projeto_id, papel, data_inicio, data_fim } = req.body;
    const result = await pool.query(
      "INSERT INTO contribuidores_projeto (contribuidor_id, projeto_id, papel, data_inicio, data_fim) VALUES ($1, $2, $3, $4, $5) RETURNING *",
      [contribuidor_id, projeto_id, papel, data_inicio, data_fim]
    );
    res.status(201).json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Buscar relaÃ§Ã£o contribuidor-projeto por ID
exports.show = async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query(
      "SELECT cp.*, c.nome as contribuidor_nome, p.nome as projeto_nome " +
      "FROM contribuidores_projeto cp " +
      "INNER JOIN contribuidores c ON cp.contribuidor_id = c.id " +
      "INNER JOIN projetos p ON cp.projeto_id = p.id " +
      "WHERE cp.id = $1",
      [id]
    );
    if (result.rows.length === 0) {
      return res.status(404).json({ message: "RelaÃ§Ã£o contribuidor-projeto nÃ£o encontrada" });
    }
    res.json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Atualizar relaÃ§Ã£o contribuidor-projeto
exports.update = async (req, res) => {
  try {
    const { id } = req.params;
    const { contribuidor_id, projeto_id, papel, data_inicio, data_fim } = req.body;
    const result = await pool.query(
      "UPDATE contribuidores_projeto SET contribuidor_id=$1, projeto_id=$2, papel=$3, data_inicio=$4, data_fim=$5 WHERE id=$6 RETURNING *",
      [contribuidor_id, projeto_id, papel, data_inicio, data_fim, id]
    );
    if (result.rows.length === 0) {
      return res.status(404).json({ message: "RelaÃ§Ã£o contribuidor-projeto nÃ£o encontrada" });
    }
    res.json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Deletar relaÃ§Ã£o contribuidor-projeto
exports.delete = async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query("DELETE FROM contribuidores_projeto WHERE id = $1 RETURNING *", [id]);
    if (result.rows.length === 0) {
      return res.status(404).json({ message: "RelaÃ§Ã£o contribuidor-projeto nÃ£o encontrada" });
    }
    res.json({ message: "RelaÃ§Ã£o contribuidor-projeto deletada com sucesso" });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Listar por projeto
exports.byProjeto = async (req, res) => {
  try {
    const { projetoId } = req.params;
    const result = await pool.query(
      "SELECT cp.*, c.nome as contribuidor_nome " +
      "FROM contribuidores_projeto cp " +
      "INNER JOIN contribuidores c ON cp.contribuidor_id = c.id " +
      "WHERE cp.projeto_id = $1",
      [projetoId]
    );
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Listar por contribuidor
exports.byContribuidor = async (req, res) => {
  try {
    const { contribuidorId } = req.params;
    const result = await pool.query(
      "SELECT cp.*, p.nome as projeto_nome " +
      "FROM contribuidores_projeto cp " +
      "INNER JOIN projetos p ON cp.projeto_id = p.id " +
      "WHERE cp.contribuidor_id = $1",
      [contribuidorId]
    );
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};
