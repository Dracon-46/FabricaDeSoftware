const pool = require("../../db");

// Listar todos os logs
exports.index = async (req, res) => {
  try {
    const result = await pool.query("SELECT * FROM logs ORDER BY data_hora DESC");
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Salvar novo log
exports.store = async (req, res) => {
  try {
    const { usuario_id, tipo, descricao } = req.body;
    const result = await pool.query(
      "INSERT INTO logs (usuario_id, tipo, descricao, data_hora) VALUES ($1, $2, $3, CURRENT_TIMESTAMP) RETURNING *",
      [usuario_id, tipo, descricao]
    );
    res.status(201).json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Buscar log por ID
exports.show = async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query("SELECT * FROM logs WHERE id = $1", [id]);
    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Log nÃ£o encontrado" });
    }
    res.json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Deletar log
exports.delete = async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query("DELETE FROM logs WHERE id = $1 RETURNING *", [id]);
    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Log nÃ£o encontrado" });
    }
    res.json({ message: "Log deletado com sucesso" });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Listar logs por usuÃ¡rio
exports.byUsuario = async (req, res) => {
  try {
    const { usuarioId } = req.params;
    const result = await pool.query(
      "SELECT * FROM logs WHERE usuario_id = $1 ORDER BY data_hora DESC",
      [usuarioId]
    );
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Listar logs por tipo
exports.byTipo = async (req, res) => {
  try {
    const { tipo } = req.params;
    const result = await pool.query(
      "SELECT * FROM logs WHERE tipo = $1 ORDER BY data_hora DESC",
      [tipo]
    );
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};
