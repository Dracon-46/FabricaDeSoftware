const pool = require("../../db"); // Ajuste o caminho se necessário

// Listar todos os recursos
exports.index = async (req, res) => {
  try {
    // Adicionado ORDER BY para consistência
    const result = await pool.query("SELECT * FROM recursos ORDER BY nome ASC");
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Salvar novo recurso
exports.store = async (req, res) => {
  try {
    // Corrigido para usar os campos do model 'recurso.dart'
    const { nome, tipo, disponivel, descricao, criado_por_id } = req.body;

    // Validação básica
    if (!nome || !tipo || criado_por_id == null) {
      return res.status(400).json({ message: "Campos 'nome', 'tipo' e 'criado_por_id' são obrigatórios." });
    }

    const result = await pool.query(
      "INSERT INTO recursos (nome, tipo, disponivel, descricao, criado_por_id) VALUES ($1, $2, $3, $4, $5) RETURNING *",
      // Usa 'disponivel ?? true' para garantir um valor default
      [nome, tipo, disponivel ?? true, descricao, criado_por_id]
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
      return res.status(404).json({ message: "Recurso não encontrado" });
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
    // Campos corretos: Não inclui 'criado_por_id'
    const { nome, tipo, disponivel, descricao } = req.body;

    if (!nome || !tipo) {
      return res.status(400).json({ message: "Campos 'nome' e 'tipo' são obrigatórios." });
    }

    const result = await pool.query(
      "UPDATE recursos SET nome=$1, tipo=$2, disponivel=$3, descricao=$4 WHERE id=$5 RETURNING *",
      [nome, tipo, disponivel, descricao, id]
    );
    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Recurso não encontrado" });
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
      return res.status(404).json({ message: "Recurso não encontrado" });
    }
    res.json({ message: "Recurso deletado com sucesso" });
  } catch (error) {
     // Tratamento de erro para FK (violação de chave estrangeira)
    if (error.code === '23503') { 
      return res.status(409).json({ message: "Não é possível excluir. O recurso está alocado em um projeto." });
    }
    res.status(500).json({ error: error.message });
  }
};

// Listar projetos que usam o recurso (função extra que já existia)
exports.projetos = async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query(
      "SELECT p.*, rp.data_alocacao, rp.custo_hora " +
      "FROM projetos p " +
      "INNER JOIN recursos_projeto rp ON p.id = rp.projeto_id " +
      "WHERE rp.recurso_id = $1",
      [id]
    );
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};