const pool = require("../../db");

// Listar todos os clientes
exports.index = async (req, res) => {
  try {
    // Este (SELECT *) está correto.
    const result = await pool.query("SELECT * FROM clientes");
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Salvar novo cliente
exports.store = async (req, res) => {
  try {
    // 1. CORRIGIDO: Lê 'razao_social' e os outros campos do modelo
    const { razao_social, cnpj, email, telefone, setor, contato, endereco_id } = req.body;
    
    // 2. CORRIGIDO: Usa 'razao_social' e os outros campos no INSERT
    const result = await pool.query(
      "INSERT INTO clientes (razao_social, cnpj, email, telefone, setor, contato, endereco_id) VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING *",
      [razao_social, cnpj, email, telefone, setor, contato, endereco_id]
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
      return res.status(404).json({ message: "Cliente não encontrado" });
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
    // 1. CORRIGIDO: Lê 'razao_social' e os outros campos
    const { razao_social, cnpj, email, telefone, setor, contato, endereco_id } = req.body;
    
    // 2. CORRIGIDO: Usa 'razao_social' e os outros campos no UPDATE
    const result = await pool.query(
      "UPDATE clientes SET razao_social=$1, cnpj=$2, email=$3, telefone=$4, setor=$5, contato=$6, endereco_id=$7 WHERE id=$8 RETURNING *",
      [razao_social, cnpj, email, telefone, setor, contato, endereco_id, id]
    );
    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Cliente não encontrado" });
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
      return res.status(404).json({ message: "Cliente não encontrado" });
    }
    res.json({ message: "Cliente deletado com sucesso" });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Buscar detalhes completos do cliente (Esta função estava a faltar no teu ficheiro original)
exports.details = async (req, res) => {
  try {
    const { id } = req.params;
    
    const clienteResult = await pool.query("SELECT * FROM clientes WHERE id = $1", [id]);
    if (clienteResult.rows.length === 0) {
      return res.status(404).json({ message: "Cliente não encontrado" });
    }
    const cliente = clienteResult.rows[0];

    // (O teu 'index.js' não tem uma rota /enderecos/:cliente_id,
    //  mas o teu modelo 'cliente.dart' tem 'endereco_id',
    //  então vou assumir que o endereço é buscado separadamente ou está noutra rota)
    // const enderecosResult = ...

    // (O teu 'index.js' tem esta rota)
    const projetosResult = await pool.query(
      "SELECT * FROM projetos WHERE cliente_id = $1",
      [id]
    );

    res.json({
      ...cliente,
      // enderecos: enderecosResult.rows,
      projetos: projetosResult.rows
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};