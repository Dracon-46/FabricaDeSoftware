const pool = require("../../db");

// Listar todas as tecnologias
exports.index = async (req, res) => {
  try {
    const result = await pool.query("SELECT * FROM tecnologias");
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Salvar nova tecnologia
exports.store = async (req, res) => {
  try {
    const { nome, descricao, categoria, versao } = req.body;
    const result = await pool.query(
      "INSERT INTO tecnologias (nome, descricao, categoria, versao) VALUES ($1, $2, $3, $4) RETURNING *",
      [nome, descricao, categoria, versao]
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
      return res.status(404).json({ message: "Tecnologia nÃ£o encontrada" });
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
    const { nome, descricao, categoria, versao } = req.body;
    const result = await pool.query(
      "UPDATE tecnologias SET nome=$1, descricao=$2, categoria=$3, versao=$4 WHERE id=$5 RETURNING *",
      [nome, descricao, categoria, versao, id]
    );
    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Tecnologia nÃ£o encontrada" });
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
      return res.status(404).json({ message: "Tecnologia nÃ£o encontrada" });
    }
    res.json({ message: "Tecnologia deletada com sucesso" });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Listar projetos que usam a tecnologia
exports.projetos = async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query(
      "SELECT p.* FROM projetos p " +
      "INNER JOIN tecnologias_projeto tp ON p.id = tp.projeto_id " +
      "WHERE tp.tecnologia_id = $1",
      [id]
    );
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Listar por categoria
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
