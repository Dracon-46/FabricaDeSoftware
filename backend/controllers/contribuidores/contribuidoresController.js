const pool = require("../../db");

// Listar todos os contribuidores
exports.index = async (req, res) => {
  try {
    const result = await pool.query("SELECT * FROM contribuidores");
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Salvar novo contribuidor
exports.store = async (req, res) => {
  try {
    const { nome, email, cargo, especialidade, nivel_experiencia } = req.body;
    const result = await pool.query(
      "INSERT INTO contribuidores (nome, email, cargo, especialidade, nivel_experiencia) VALUES ($1, $2, $3, $4, $5) RETURNING *",
      [nome, email, cargo, especialidade, nivel_experiencia]
    );
    res.status(201).json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Buscar contribuidor por ID
exports.show = async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query("SELECT * FROM contribuidores WHERE id = $1", [id]);
    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Contribuidor nÃ£o encontrado" });
    }
    res.json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Atualizar contribuidor
exports.update = async (req, res) => {
  try {
    const { id } = req.params;
    const { nome, email, cargo, especialidade, nivel_experiencia } = req.body;
    const result = await pool.query(
      "UPDATE contribuidores SET nome=$1, email=$2, cargo=$3, especialidade=$4, nivel_experiencia=$5 WHERE id=$6 RETURNING *",
      [nome, email, cargo, especialidade, nivel_experiencia, id]
    );
    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Contribuidor nÃ£o encontrado" });
    }
    res.json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Deletar contribuidor
exports.delete = async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query("DELETE FROM contribuidores WHERE id = $1 RETURNING *", [id]);
    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Contribuidor nÃ£o encontrado" });
    }
    res.json({ message: "Contribuidor deletado com sucesso" });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Buscar projetos do contribuidor
exports.projetos = async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query(
      "SELECT p.* FROM projetos p " +
      "INNER JOIN contribuidores_projeto cp ON p.id = cp.projeto_id " +
      "WHERE cp.contribuidor_id = $1",
      [id]
    );
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};
