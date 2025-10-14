const pool = require("../../db");

// Listar todos os clientes
exports.index = async (req, res) => {
  try {
    const result = await pool.query("SELECT * FROM clientes");
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Salvar novo cliente
exports.store = async (req, res) => {
  try {
    const { nome, email, telefone, cnpj } = req.body;
    const result = await pool.query(
      "INSERT INTO clientes (nome, email, telefone, cnpj) VALUES ($1, $2, $3, $4) RETURNING *",
      [nome, email, telefone, cnpj]
    );
    res.status(201).json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Buscar cliente por ID
exports.show = async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query("SELECT * FROM clientes WHERE id = $1", [id]);
    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Cliente nÃ£o encontrado" });
    }
    res.json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Atualizar cliente
exports.update = async (req, res) => {
  try {
    const { id } = req.params;
    const { nome, email, telefone, cnpj } = req.body;
    const result = await pool.query(
      "UPDATE clientes SET nome=$1, email=$2, telefone=$3, cnpj=$4 WHERE id=$5 RETURNING *",
      [nome, email, telefone, cnpj, id]
    );
    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Cliente nÃ£o encontrado" });
    }
    res.json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Deletar cliente
exports.delete = async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query("DELETE FROM clientes WHERE id = $1 RETURNING *", [id]);
    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Cliente nÃ£o encontrado" });
    }
    res.json({ message: "Cliente deletado com sucesso" });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Buscar detalhes completos do cliente
exports.details = async (req, res) => {
  try {
    const { id } = req.params;
    
    // Busca o cliente
    const clienteResult = await pool.query("SELECT * FROM clientes WHERE id = $1", [id]);
    if (clienteResult.rows.length === 0) {
      return res.status(404).json({ message: "Cliente nÃ£o encontrado" });
    }
    const cliente = clienteResult.rows[0];

    // Busca endereÃ§os do cliente
    const enderecosResult = await pool.query(
      "SELECT * FROM enderecos WHERE cliente_id = $1",
      [id]
    );

    // Busca projetos do cliente
    const projetosResult = await pool.query(
      "SELECT * FROM projetos WHERE cliente_id = $1",
      [id]
    );

    // Retorna todos os detalhes do cliente
    res.json({
      ...cliente,
      enderecos: enderecosResult.rows,
      projetos: projetosResult.rows
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};
