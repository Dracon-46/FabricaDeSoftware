const pool = require("../../db");

// Listar todos os recursos
exports.index = async (req, res) => {
  try {
    const result = await pool.query("SELECT * FROM recursos");
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Salvar novo recurso
exports.store = async (req, res) => {
  try {
    const { nome, tipo, descricao, custo_hora } = req.body;
    const result = await pool.query(
      "INSERT INTO recursos (nome, tipo, descricao, custo_hora) VALUES ($1, $2, $3, $4) RETURNING *",
      [nome, tipo, descricao, custo_hora]
    );
    res.status(201).json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Buscar recurso por ID
exports.show = async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query("SELECT * FROM recursos WHERE id = $1", [id]);
    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Recurso nÃ£o encontrado" });
    }
    res.json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Atualizar recurso
exports.update = async (req, res) => {
  try {
    const { id } = req.params;
    const { nome, tipo, descricao, custo_hora } = req.body;
    const result = await pool.query(
      "UPDATE recursos SET nome=$1, tipo=$2, descricao=$3, custo_hora=$4 WHERE id=$5 RETURNING *",
      [nome, tipo, descricao, custo_hora, id]
    );
    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Recurso nÃ£o encontrado" });
    }
    res.json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Deletar recurso
exports.delete = async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query("DELETE FROM recursos WHERE id = $1 RETURNING *", [id]);
    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Recurso nÃ£o encontrado" });
    }
    res.json({ message: "Recurso deletado com sucesso" });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Listar projetos que usam o recurso
exports.projetos = async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query(
      "SELECT p.* FROM projetos p " +
      "INNER JOIN recursos_projeto rp ON p.id = rp.projeto_id " +
      "WHERE rp.recurso_id = $1",
      [id]
    );
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};
