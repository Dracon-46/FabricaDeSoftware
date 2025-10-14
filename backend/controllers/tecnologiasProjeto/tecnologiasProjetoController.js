const pool = require("../../db");

// Listar todas as tecnologias do projeto
exports.index = async (req, res) => {
  try {
    const result = await pool.query("SELECT * FROM tecnologias_projeto");
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Adicionar tecnologia ao projeto
exports.store = async (req, res) => {
  try {
    const { projeto_id, tecnologia_id, nivel_proficiencia } = req.body;
    const result = await pool.query(
      "INSERT INTO tecnologias_projeto (projeto_id, tecnologia_id, nivel_proficiencia) VALUES ($1, $2, $3) RETURNING *",
      [projeto_id, tecnologia_id, nivel_proficiencia]
    );
    res.status(201).json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Buscar tecnologia do projeto por ID
exports.show = async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query("SELECT * FROM tecnologias_projeto WHERE id = $1", [id]);
    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Tecnologia do projeto nÃ£o encontrada" });
    }
    res.json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Atualizar tecnologia do projeto
exports.update = async (req, res) => {
  try {
    const { id } = req.params;
    const { projeto_id, tecnologia_id, nivel_proficiencia } = req.body;
    const result = await pool.query(
      "UPDATE tecnologias_projeto SET projeto_id=$1, tecnologia_id=$2, nivel_proficiencia=$3 WHERE id=$4 RETURNING *",
      [projeto_id, tecnologia_id, nivel_proficiencia, id]
    );
    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Tecnologia do projeto nÃ£o encontrada" });
    }
    res.json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Deletar tecnologia do projeto
exports.delete = async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query("DELETE FROM tecnologias_projeto WHERE id = $1 RETURNING *", [id]);
    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Tecnologia do projeto nÃ£o encontrada" });
    }
    res.json({ message: "Tecnologia removida do projeto com sucesso" });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Listar tecnologias por projeto
exports.byProjeto = async (req, res) => {
  try {
    const { projeto_id } = req.params;
    const result = await pool.query(
      "SELECT t.*, tp.nivel_proficiencia FROM tecnologias t " +
      "INNER JOIN tecnologias_projeto tp ON t.id = tp.tecnologia_id " +
      "WHERE tp.projeto_id = $1",
      [projeto_id]
    );
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};
