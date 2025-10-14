const pool = require("../../db");

// Listar todos os endereÃ§os
exports.index = async (req, res) => {
  try {
    const result = await pool.query("SELECT * FROM enderecos");
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Salvar novo endereÃ§o
exports.store = async (req, res) => {
  try {
    const { rua, numero, complemento, bairro, cidade, estado, cep, cliente_id } = req.body;
    const result = await pool.query(
      "INSERT INTO enderecos (rua, numero, complemento, bairro, cidade, estado, cep, cliente_id) VALUES ($1, $2, $3, $4, $5, $6, $7, $8) RETURNING *",
      [rua, numero, complemento, bairro, cidade, estado, cep, cliente_id]
    );
    res.status(201).json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Buscar endereÃ§o por ID
exports.show = async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query("SELECT * FROM enderecos WHERE id = $1", [id]);
    if (result.rows.length === 0) {
      return res.status(404).json({ message: "EndereÃ§o nÃ£o encontrado" });
    }
    res.json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Atualizar endereÃ§o
exports.update = async (req, res) => {
  try {
    const { id } = req.params;
    const { rua, numero, complemento, bairro, cidade, estado, cep, cliente_id } = req.body;
    const result = await pool.query(
      "UPDATE enderecos SET rua=$1, numero=$2, complemento=$3, bairro=$4, cidade=$5, estado=$6, cep=$7, cliente_id=$8 WHERE id=$9 RETURNING *",
      [rua, numero, complemento, bairro, cidade, estado, cep, cliente_id, id]
    );
    if (result.rows.length === 0) {
      return res.status(404).json({ message: "EndereÃ§o nÃ£o encontrado" });
    }
    res.json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Deletar endereÃ§o
exports.delete = async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query("DELETE FROM enderecos WHERE id = $1 RETURNING *", [id]);
    if (result.rows.length === 0) {
      return res.status(404).json({ message: "EndereÃ§o nÃ£o encontrado" });
    }
    res.json({ message: "EndereÃ§o deletado com sucesso" });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Listar endereÃ§os por cliente
exports.byCliente = async (req, res) => {
  try {
    const { clienteId } = req.params;
    const result = await pool.query("SELECT * FROM enderecos WHERE cliente_id = $1", [clienteId]);
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};
