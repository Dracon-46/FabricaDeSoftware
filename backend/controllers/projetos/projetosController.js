const pool = require("../../db");

// Listar todos os projetos
exports.index = async (req, res) => {
  try {
    const result = await pool.query("SELECT * FROM projetos");
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Salvar novo projeto
exports.store = async (req, res) => {
  try {
    const { nome, descricao, data_inicio, data_fim, status, cliente_id } = req.body;
    const result = await pool.query(
      "INSERT INTO projetos (nome, descricao, data_inicio, data_fim, status, cliente_id) VALUES ($1, $2, $3, $4, $5, $6) RETURNING *",
      [nome, descricao, data_inicio, data_fim, status, cliente_id]
    );
    res.status(201).json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Buscar projeto por ID
exports.show = async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query("SELECT * FROM projetos WHERE id = $1", [id]);
    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Projeto nÃ£o encontrado" });
    }
    res.json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Atualizar projeto
exports.update = async (req, res) => {
  try {
    const { id } = req.params;
    const { nome, descricao, data_inicio, data_fim, status, cliente_id } = req.body;
    const result = await pool.query(
      "UPDATE projetos SET nome=$1, descricao=$2, data_inicio=$3, data_fim=$4, status=$5, cliente_id=$6 WHERE id=$7 RETURNING *",
      [nome, descricao, data_inicio, data_fim, status, cliente_id, id]
    );
    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Projeto nÃ£o encontrado" });
    }
    res.json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Deletar projeto
exports.delete = async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query("DELETE FROM projetos WHERE id = $1 RETURNING *", [id]);
    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Projeto nÃ£o encontrado" });
    }
    res.json({ message: "Projeto deletado com sucesso" });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Listar projetos por cliente
exports.byCliente = async (req, res) => {
  try {
    const { clienteId } = req.params;
    const result = await pool.query("SELECT * FROM projetos WHERE cliente_id = $1", [clienteId]);
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Buscar detalhes completos do projeto
exports.details = async (req, res) => {
  try {
    const { id } = req.params;
    
    // Busca o projeto
    const projetoResult = await pool.query("SELECT * FROM projetos WHERE id = $1", [id]);
    if (projetoResult.rows.length === 0) {
      return res.status(404).json({ message: "Projeto nÃ£o encontrado" });
    }
    const projeto = projetoResult.rows[0];

    // Busca contribuidores do projeto
    const contribuidoresResult = await pool.query(
      "SELECT c.* FROM contribuidores c " +
      "INNER JOIN contribuidores_projeto cp ON c.id = cp.contribuidor_id " +
      "WHERE cp.projeto_id = $1",
      [id]
    );

    // Busca recursos do projeto
    const recursosResult = await pool.query(
      "SELECT r.* FROM recursos r " +
      "INNER JOIN recursos_projeto rp ON r.id = rp.recurso_id " +
      "WHERE rp.projeto_id = $1",
      [id]
    );

    // Busca tecnologias do projeto
    const tecnologiasResult = await pool.query(
      "SELECT t.* FROM tecnologias t " +
      "INNER JOIN tecnologias_projeto tp ON t.id = tp.tecnologia_id " +
      "WHERE tp.projeto_id = $1",
      [id]
    );

    // Busca requisitos do projeto
    const requisitosResult = await pool.query(
      "SELECT r.* FROM requisitos r " +
      "INNER JOIN requisitos_projeto rp ON r.id = rp.requisito_id " +
      "WHERE rp.projeto_id = $1",
      [id]
    );

    // Retorna todos os detalhes do projeto
    res.json({
      ...projeto,
      contribuidores: contribuidoresResult.rows,
      recursos: recursosResult.rows,
      tecnologias: tecnologiasResult.rows,
      requisitos: requisitosResult.rows
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};
