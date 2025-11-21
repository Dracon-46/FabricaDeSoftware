const pool = require("../../db");

// Listar todas as tecnologias
exports.index = async (req, res) => {
  try {
    const result = await pool.query("SELECT * FROM tecnologias ORDER BY nome ASC");
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Salvar nova tecnologia
exports.store = async (req, res) => {
  try {
    // CORRIGIDO: Removido 'versao' e alinhado com o banco e o model
    const { nome, categoria, descricao } = req.body;

    if (!nome) {
       return res.status(400).json({ message: "O campo 'nome' é obrigatório." });
    }

    const result = await pool.query(
      "INSERT INTO tecnologias (nome, categoria, descricao) VALUES ($1, $2, $3) RETURNING *",
      [nome, categoria, descricao]
    );
    res.status(201).json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Buscar tecnologia por ID
exports.show = async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query("SELECT * FROM tecnologias WHERE id = $1", [id]);
    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Tecnologia não encontrada" });
    }
    res.json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Atualizar tecnologia
exports.update = async (req, res) => {
  try {
    const { id } = req.params;
    // CORRIGIDO: Removido 'versao'
    const { nome, categoria, descricao } = req.body;

    if (!nome) {
       return res.status(400).json({ message: "O campo 'nome' é obrigatório." });
    }

    const result = await pool.query(
      "UPDATE tecnologias SET nome=$1, categoria=$2, descricao=$3 WHERE id=$4 RETURNING *",
      [nome, categoria, descricao, id]
    );
    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Tecnologia não encontrada" });
    }
    res.json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Deletar tecnologia
exports.delete = async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query("DELETE FROM tecnologias WHERE id = $1 RETURNING *", [id]);
    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Tecnologia não encontrada" });
    }
    res.json({ message: "Tecnologia deletada com sucesso" });
  } catch (error) {
    // Tratamento de erro para FK (violação de chave estrangeira)
    if (error.code === '23503') { 
      return res.status(409).json({ message: "Não é possível excluir. A tecnologia está associada a um projeto." });
    }
    res.status(500).json({ error: error.message });
  }
};

// Listar projetos que usam a tecnologia (função extra que já existia)
exports.projetos = async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query(
      "SELECT p.*, tp.data_aprovacao " +
      "FROM projetos p " +
      "INNER JOIN tecnologias_projeto tp ON p.id = tp.projeto_id " +
      "WHERE tp.tecnologia_id = $1",
      [id]
    );
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

exports.byCategoria = async (req, res) => {
  try {
    const { categoria } = req.params;
    const result = await pool.query(
      "SELECT * FROM tecnologias WHERE categoria = $1",
      [categoria]
    );
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};