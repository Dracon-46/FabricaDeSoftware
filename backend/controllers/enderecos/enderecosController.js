const pool = require("../../db");

// Listar todos os endereços
exports.index = async (req, res) => {
  try {
    const result = await pool.query("SELECT * FROM enderecos");
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Salvar novo endereço
exports.store = async (req, res) => {
  try {
    // CORRIGIDO: Removido cliente_id, trocado 'rua' por 'logradouro'
    const { logradouro, numero, complemento, bairro, cidade, estado, cep, pais } = req.body;
    const result = await pool.query(
      "INSERT INTO enderecos (logradouro, numero, complemento, bairro, cidade, estado, cep, pais) VALUES ($1, $2, $3, $4, $5, $6, $7, $8) RETURNING *",
      [logradouro, numero, complemento, bairro, cidade, estado, cep, pais]
    );
    res.status(201).json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Buscar endereço por ID
exports.show = async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query("SELECT * FROM enderecos WHERE id = $1", [id]);
    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Endereço não encontrado" });
    }
    res.json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Atualizar endereço
exports.update = async (req, res) => {
  try {
    const { id } = req.params;
    // CORRIGIDO: Removido cliente_id, trocado 'rua' por 'logradouro'
    const { logradouro, numero, complemento, bairro, cidade, estado, cep, pais } = req.body;
    const result = await pool.query(
      "UPDATE enderecos SET logradouro=$1, numero=$2, complemento=$3, bairro=$4, cidade=$5, estado=$6, cep=$7, pais=$8 WHERE id=$9 RETURNING *",
      [logradouro, numero, complemento, bairro, cidade, estado, cep, pais, id]
    );
    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Endereço não encontrado" });
    }
    res.json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Deletar endereço
exports.delete = async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query("DELETE FROM enderecos WHERE id = $1 RETURNING *", [id]);
    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Endereço não encontrado" });
    }
    res.json({ message: "Endereço deletado com sucesso" });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// (REMOVIDO 'byCliente' pois a tabela 'enderecos' não possui 'cliente_id')