const pool = require("../../db");

// Listar todos os treinamentos
exports.index = async (req, res) => {
  try {
    const result = await pool.query("SELECT * FROM treinamentos");
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Salvar novo treinamento
exports.store = async (req, res) => {
  try {
    const { nome, descricao, tipo, status, data_inicio, data_fim, instrutor_id } = req.body;
    const result = await pool.query(
      "INSERT INTO treinamentos (nome, descricao, tipo, status, data_inicio, data_fim, instrutor_id) VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING *",
      [nome, descricao, tipo, status, data_inicio, data_fim, instrutor_id]
    );
    res.status(201).json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Buscar treinamento por ID
exports.show = async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query("SELECT * FROM treinamentos WHERE id = $1", [id]);
    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Treinamento nÃ£o encontrado" });
    }
    res.json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Atualizar treinamento
exports.update = async (req, res) => {
  try {
    const { id } = req.params;
    const { nome, descricao, tipo, status, data_inicio, data_fim, instrutor_id } = req.body;
    const result = await pool.query(
      "UPDATE treinamentos SET nome=$1, descricao=$2, tipo=$3, status=$4, data_inicio=$5, data_fim=$6, instrutor_id=$7 WHERE id=$8 RETURNING *",
      [nome, descricao, tipo, status, data_inicio, data_fim, instrutor_id, id]
    );
    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Treinamento nÃ£o encontrado" });
    }
    res.json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Deletar treinamento
exports.delete = async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query("DELETE FROM treinamentos WHERE id = $1 RETURNING *", [id]);
    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Treinamento nÃ£o encontrado" });
    }
    res.json({ message: "Treinamento deletado com sucesso" });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Listar treinamentos por status
exports.byStatus = async (req, res) => {
  try {
    const { status } = req.params;
    const result = await pool.query(
      "SELECT * FROM treinamentos WHERE status = $1",
      [status]
    );
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Listar treinamentos por instrutor
exports.byInstrutor = async (req, res) => {
  try {
    const { instrutor_id } = req.params;
    const result = await pool.query(
      "SELECT * FROM treinamentos WHERE instrutor_id = $1",
      [instrutor_id]
    );
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};
