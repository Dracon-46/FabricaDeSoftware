# Deletar os arquivos existentes
Remove-Item -Path "controllers\usuarios\usuariosController.js" -Force -ErrorAction SilentlyContinue
Remove-Item -Path "controllers\projetos\projetosController.js" -Force -ErrorAction SilentlyContinue
Remove-Item -Path "controllers\clientes\clientesController.js" -Force -ErrorAction SilentlyContinue
Remove-Item -Path "controllers\enderecos\enderecosController.js" -Force -ErrorAction SilentlyContinue
Remove-Item -Path "controllers\contribuidores\contribuidoresController.js" -Force -ErrorAction SilentlyContinue
Remove-Item -Path "controllers\contribuidoresProjeto\contribuidoresProjetoController.js" -Force -ErrorAction SilentlyContinue
Remove-Item -Path "controllers\documentos\documentosController.js" -Force -ErrorAction SilentlyContinue
Remove-Item -Path "controllers\logs\logsController.js" -Force -ErrorAction SilentlyContinue
Remove-Item -Path "controllers\recursos\recursosController.js" -Force -ErrorAction SilentlyContinue
Remove-Item -Path "controllers\recursosProjeto\recursosProjetoController.js" -Force -ErrorAction SilentlyContinue
Remove-Item -Path "controllers\requisitos\requisitosController.js" -Force -ErrorAction SilentlyContinue
Remove-Item -Path "controllers\requisitosProjeto\requisitosProjetoController.js" -Force -ErrorAction SilentlyContinue
Remove-Item -Path "controllers\tecnologias\tecnologiasController.js" -Force -ErrorAction SilentlyContinue

# Conteúdo do usuariosController.js
$usuariosContent = @'
const pool = require("../../db");
const bcrypt = require("bcrypt");

// Listar todos os usuários
exports.index = async (req, res) => {
  try {
    const result = await pool.query("SELECT id, nome, email, cargo FROM usuarios");
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Salvar novo usuário
exports.store = async (req, res) => {
  try {
    const { nome, email, senha, cargo } = req.body;
    const hashedSenha = await bcrypt.hash(senha, 10);
    const result = await pool.query(
      "INSERT INTO usuarios (nome, email, senha, cargo) VALUES ($1, $2, $3, $4) RETURNING id, nome, email, cargo",
      [nome, email, hashedSenha, cargo]
    );
    res.status(201).json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Buscar usuário por ID
exports.show = async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query(
      "SELECT id, nome, email, cargo FROM usuarios WHERE id = $1",
      [id]
    );
    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Usuário não encontrado" });
    }
    res.json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Atualizar usuário
exports.update = async (req, res) => {
  try {
    const { id } = req.params;
    const { nome, email, senha, cargo } = req.body;

    let query;
    let params;

    if (senha) {
      const hashedSenha = await bcrypt.hash(senha, 10);
      query = "UPDATE usuarios SET nome=$1, email=$2, senha=$3, cargo=$4 WHERE id=$5 RETURNING id, nome, email, cargo";
      params = [nome, email, hashedSenha, cargo, id];
    } else {
      query = "UPDATE usuarios SET nome=$1, email=$2, cargo=$3 WHERE id=$4 RETURNING id, nome, email, cargo";
      params = [nome, email, cargo, id];
    }

    const result = await pool.query(query, params);
    
    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Usuário não encontrado" });
    }
    res.json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Deletar usuário
exports.delete = async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query("DELETE FROM usuarios WHERE id = $1 RETURNING *", [id]);
    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Usuário não encontrado" });
    }
    res.json({ message: "Usuário deletado com sucesso" });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};
'@

# Conteúdo do projetosController.js
$projetosContent = @'
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
      return res.status(404).json({ message: "Projeto não encontrado" });
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
      return res.status(404).json({ message: "Projeto não encontrado" });
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
      return res.status(404).json({ message: "Projeto não encontrado" });
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
      return res.status(404).json({ message: "Projeto não encontrado" });
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
'@

# Conteúdo do clientesController.js
$clientesContent = @'
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
    const { nome, email, telefone, cnpj } = req.body;
    const result = await pool.query(
      "UPDATE clientes SET nome=$1, email=$2, telefone=$3, cnpj=$4 WHERE id=$5 RETURNING *",
      [nome, email, telefone, cnpj, id]
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

// Buscar detalhes completos do cliente
exports.details = async (req, res) => {
  try {
    const { id } = req.params;
    
    // Busca o cliente
    const clienteResult = await pool.query("SELECT * FROM clientes WHERE id = $1", [id]);
    if (clienteResult.rows.length === 0) {
      return res.status(404).json({ message: "Cliente não encontrado" });
    }
    const cliente = clienteResult.rows[0];

    // Busca endereços do cliente
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
'@

# Conteúdo do enderecosController.js
$enderecosContent = @'
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
    const { rua, numero, complemento, bairro, cidade, estado, cep, cliente_id } = req.body;
    const result = await pool.query(
      "UPDATE enderecos SET rua=$1, numero=$2, complemento=$3, bairro=$4, cidade=$5, estado=$6, cep=$7, cliente_id=$8 WHERE id=$9 RETURNING *",
      [rua, numero, complemento, bairro, cidade, estado, cep, cliente_id, id]
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

// Listar endereços por cliente
exports.byCliente = async (req, res) => {
  try {
    const { clienteId } = req.params;
    const result = await pool.query("SELECT * FROM enderecos WHERE cliente_id = $1", [clienteId]);
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};
'@

# Conteúdo do contribuidoresController.js
$contribuidoresContent = @'
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
      return res.status(404).json({ message: "Contribuidor não encontrado" });
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
      return res.status(404).json({ message: "Contribuidor não encontrado" });
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
      return res.status(404).json({ message: "Contribuidor não encontrado" });
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
'@

# Conteúdo do contribuidoresProjetoController.js
$contribuidoresProjetoContent = @'
const pool = require("../../db");

// Listar todas as relações contribuidor-projeto
exports.index = async (req, res) => {
  try {
    const result = await pool.query(
      "SELECT cp.*, c.nome as contribuidor_nome, p.nome as projeto_nome " +
      "FROM contribuidores_projeto cp " +
      "INNER JOIN contribuidores c ON cp.contribuidor_id = c.id " +
      "INNER JOIN projetos p ON cp.projeto_id = p.id"
    );
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Salvar nova relação contribuidor-projeto
exports.store = async (req, res) => {
  try {
    const { contribuidor_id, projeto_id, papel, data_inicio, data_fim } = req.body;
    const result = await pool.query(
      "INSERT INTO contribuidores_projeto (contribuidor_id, projeto_id, papel, data_inicio, data_fim) VALUES ($1, $2, $3, $4, $5) RETURNING *",
      [contribuidor_id, projeto_id, papel, data_inicio, data_fim]
    );
    res.status(201).json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Buscar relação contribuidor-projeto por ID
exports.show = async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query(
      "SELECT cp.*, c.nome as contribuidor_nome, p.nome as projeto_nome " +
      "FROM contribuidores_projeto cp " +
      "INNER JOIN contribuidores c ON cp.contribuidor_id = c.id " +
      "INNER JOIN projetos p ON cp.projeto_id = p.id " +
      "WHERE cp.id = $1",
      [id]
    );
    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Relação contribuidor-projeto não encontrada" });
    }
    res.json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Atualizar relação contribuidor-projeto
exports.update = async (req, res) => {
  try {
    const { id } = req.params;
    const { contribuidor_id, projeto_id, papel, data_inicio, data_fim } = req.body;
    const result = await pool.query(
      "UPDATE contribuidores_projeto SET contribuidor_id=$1, projeto_id=$2, papel=$3, data_inicio=$4, data_fim=$5 WHERE id=$6 RETURNING *",
      [contribuidor_id, projeto_id, papel, data_inicio, data_fim, id]
    );
    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Relação contribuidor-projeto não encontrada" });
    }
    res.json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Deletar relação contribuidor-projeto
exports.delete = async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query("DELETE FROM contribuidores_projeto WHERE id = $1 RETURNING *", [id]);
    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Relação contribuidor-projeto não encontrada" });
    }
    res.json({ message: "Relação contribuidor-projeto deletada com sucesso" });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Listar por projeto
exports.byProjeto = async (req, res) => {
  try {
    const { projetoId } = req.params;
    const result = await pool.query(
      "SELECT cp.*, c.nome as contribuidor_nome " +
      "FROM contribuidores_projeto cp " +
      "INNER JOIN contribuidores c ON cp.contribuidor_id = c.id " +
      "WHERE cp.projeto_id = $1",
      [projetoId]
    );
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Listar por contribuidor
exports.byContribuidor = async (req, res) => {
  try {
    const { contribuidorId } = req.params;
    const result = await pool.query(
      "SELECT cp.*, p.nome as projeto_nome " +
      "FROM contribuidores_projeto cp " +
      "INNER JOIN projetos p ON cp.projeto_id = p.id " +
      "WHERE cp.contribuidor_id = $1",
      [contribuidorId]
    );
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};
'@

# Conteúdo do documentosController.js
$documentosContent = @'
const pool = require("../../db");

// Listar todos os documentos
exports.index = async (req, res) => {
  try {
    const result = await pool.query("SELECT * FROM documentos");
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Salvar novo documento
exports.store = async (req, res) => {
  try {
    const { nome, tipo, url, projeto_id, descricao } = req.body;
    const result = await pool.query(
      "INSERT INTO documentos (nome, tipo, url, projeto_id, descricao) VALUES ($1, $2, $3, $4, $5) RETURNING *",
      [nome, tipo, url, projeto_id, descricao]
    );
    res.status(201).json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Buscar documento por ID
exports.show = async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query("SELECT * FROM documentos WHERE id = $1", [id]);
    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Documento não encontrado" });
    }
    res.json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Atualizar documento
exports.update = async (req, res) => {
  try {
    const { id } = req.params;
    const { nome, tipo, url, projeto_id, descricao } = req.body;
    const result = await pool.query(
      "UPDATE documentos SET nome=$1, tipo=$2, url=$3, projeto_id=$4, descricao=$5 WHERE id=$6 RETURNING *",
      [nome, tipo, url, projeto_id, descricao, id]
    );
    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Documento não encontrado" });
    }
    res.json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Deletar documento
exports.delete = async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query("DELETE FROM documentos WHERE id = $1 RETURNING *", [id]);
    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Documento não encontrado" });
    }
    res.json({ message: "Documento deletado com sucesso" });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Listar documentos por projeto
exports.byProjeto = async (req, res) => {
  try {
    const { projetoId } = req.params;
    const result = await pool.query(
      "SELECT * FROM documentos WHERE projeto_id = $1",
      [projetoId]
    );
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};
'@

# Conteúdo do logsController.js
$logsContent = @'
const pool = require("../../db");

// Listar todos os logs
exports.index = async (req, res) => {
  try {
    const result = await pool.query("SELECT * FROM logs ORDER BY data_hora DESC");
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Salvar novo log
exports.store = async (req, res) => {
  try {
    const { usuario_id, tipo, descricao } = req.body;
    const result = await pool.query(
      "INSERT INTO logs (usuario_id, tipo, descricao, data_hora) VALUES ($1, $2, $3, CURRENT_TIMESTAMP) RETURNING *",
      [usuario_id, tipo, descricao]
    );
    res.status(201).json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Buscar log por ID
exports.show = async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query("SELECT * FROM logs WHERE id = $1", [id]);
    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Log não encontrado" });
    }
    res.json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Deletar log
exports.delete = async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query("DELETE FROM logs WHERE id = $1 RETURNING *", [id]);
    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Log não encontrado" });
    }
    res.json({ message: "Log deletado com sucesso" });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Listar logs por usuário
exports.byUsuario = async (req, res) => {
  try {
    const { usuarioId } = req.params;
    const result = await pool.query(
      "SELECT * FROM logs WHERE usuario_id = $1 ORDER BY data_hora DESC",
      [usuarioId]
    );
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Listar logs por tipo
exports.byTipo = async (req, res) => {
  try {
    const { tipo } = req.params;
    const result = await pool.query(
      "SELECT * FROM logs WHERE tipo = $1 ORDER BY data_hora DESC",
      [tipo]
    );
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};
'@

# Conteúdo do recursosController.js
$recursosContent = @'
const pool = require("../../db");

// Listar todos os recursos
exports.index = async (req, res) => {
  try {
    const result = await pool.query("SELECT * FROM recursos");
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Salvar novo recurso
exports.store = async (req, res) => {
  try {
    const { nome, tipo, descricao, custo_hora } = req.body;
    const result = await pool.query(
      "INSERT INTO recursos (nome, tipo, descricao, custo_hora) VALUES ($1, $2, $3, $4) RETURNING *",
      [nome, tipo, descricao, custo_hora]
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
    const { nome, tipo, descricao, custo_hora } = req.body;
    const result = await pool.query(
      "UPDATE recursos SET nome=$1, tipo=$2, descricao=$3, custo_hora=$4 WHERE id=$5 RETURNING *",
      [nome, tipo, descricao, custo_hora, id]
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
    res.status(500).json({ error: error.message });
  }
};

// Listar projetos que usam o recurso
exports.projetos = async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query(
      "SELECT p.* FROM projetos p " +
      "INNER JOIN recursos_projeto rp ON p.id = rp.projeto_id " +
      "WHERE rp.recurso_id = $1",
      [id]
    );
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};
'@

# Conteúdo do recursosProjetoController.js
$recursosProjetoContent = @'
const pool = require("../../db");

// Listar todas as relações recurso-projeto
exports.index = async (req, res) => {
  try {
    const result = await pool.query(
      "SELECT rp.*, r.nome as recurso_nome, p.nome as projeto_nome " +
      "FROM recursos_projeto rp " +
      "INNER JOIN recursos r ON rp.recurso_id = r.id " +
      "INNER JOIN projetos p ON rp.projeto_id = p.id"
    );
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Salvar nova relação recurso-projeto
exports.store = async (req, res) => {
  try {
    const { recurso_id, projeto_id, quantidade, data_inicio, data_fim } = req.body;
    const result = await pool.query(
      "INSERT INTO recursos_projeto (recurso_id, projeto_id, quantidade, data_inicio, data_fim) VALUES ($1, $2, $3, $4, $5) RETURNING *",
      [recurso_id, projeto_id, quantidade, data_inicio, data_fim]
    );
    res.status(201).json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Buscar relação recurso-projeto por ID
exports.show = async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query(
      "SELECT rp.*, r.nome as recurso_nome, p.nome as projeto_nome " +
      "FROM recursos_projeto rp " +
      "INNER JOIN recursos r ON rp.recurso_id = r.id " +
      "INNER JOIN projetos p ON rp.projeto_id = p.id " +
      "WHERE rp.id = $1",
      [id]
    );
    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Relação recurso-projeto não encontrada" });
    }
    res.json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Atualizar relação recurso-projeto
exports.update = async (req, res) => {
  try {
    const { id } = req.params;
    const { recurso_id, projeto_id, quantidade, data_inicio, data_fim } = req.body;
    const result = await pool.query(
      "UPDATE recursos_projeto SET recurso_id=$1, projeto_id=$2, quantidade=$3, data_inicio=$4, data_fim=$5 WHERE id=$6 RETURNING *",
      [recurso_id, projeto_id, quantidade, data_inicio, data_fim, id]
    );
    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Relação recurso-projeto não encontrada" });
    }
    res.json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Deletar relação recurso-projeto
exports.delete = async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query("DELETE FROM recursos_projeto WHERE id = $1 RETURNING *", [id]);
    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Relação recurso-projeto não encontrada" });
    }
    res.json({ message: "Relação recurso-projeto deletada com sucesso" });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Listar por projeto
exports.byProjeto = async (req, res) => {
  try {
    const { projetoId } = req.params;
    const result = await pool.query(
      "SELECT rp.*, r.nome as recurso_nome " +
      "FROM recursos_projeto rp " +
      "INNER JOIN recursos r ON rp.recurso_id = r.id " +
      "WHERE rp.projeto_id = $1",
      [projetoId]
    );
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Listar por recurso
exports.byRecurso = async (req, res) => {
  try {
    const { recursoId } = req.params;
    const result = await pool.query(
      "SELECT rp.*, p.nome as projeto_nome " +
      "FROM recursos_projeto rp " +
      "INNER JOIN projetos p ON rp.projeto_id = p.id " +
      "WHERE rp.recurso_id = $1",
      [recursoId]
    );
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};
'@

# Conteúdo do requisitosController.js
$requisitosContent = @'
const pool = require("../../db");

// Listar todos os requisitos
exports.index = async (req, res) => {
  try {
    const result = await pool.query("SELECT * FROM requisitos");
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Salvar novo requisito
exports.store = async (req, res) => {
  try {
    const { nome, descricao, tipo, prioridade } = req.body;
    const result = await pool.query(
      "INSERT INTO requisitos (nome, descricao, tipo, prioridade) VALUES ($1, $2, $3, $4) RETURNING *",
      [nome, descricao, tipo, prioridade]
    );
    res.status(201).json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Buscar requisito por ID
exports.show = async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query("SELECT * FROM requisitos WHERE id = $1", [id]);
    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Requisito não encontrado" });
    }
    res.json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Atualizar requisito
exports.update = async (req, res) => {
  try {
    const { id } = req.params;
    const { nome, descricao, tipo, prioridade } = req.body;
    const result = await pool.query(
      "UPDATE requisitos SET nome=$1, descricao=$2, tipo=$3, prioridade=$4 WHERE id=$5 RETURNING *",
      [nome, descricao, tipo, prioridade, id]
    );
    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Requisito não encontrado" });
    }
    res.json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Deletar requisito
exports.delete = async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query("DELETE FROM requisitos WHERE id = $1 RETURNING *", [id]);
    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Requisito não encontrado" });
    }
    res.json({ message: "Requisito deletado com sucesso" });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Listar projetos que têm o requisito
exports.projetos = async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query(
      "SELECT p.* FROM projetos p " +
      "INNER JOIN requisitos_projeto rp ON p.id = rp.projeto_id " +
      "WHERE rp.requisito_id = $1",
      [id]
    );
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Listar por tipo
exports.byTipo = async (req, res) => {
  try {
    const { tipo } = req.params;
    const result = await pool.query(
      "SELECT * FROM requisitos WHERE tipo = $1",
      [tipo]
    );
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Listar por prioridade
exports.byPrioridade = async (req, res) => {
  try {
    const { prioridade } = req.params;
    const result = await pool.query(
      "SELECT * FROM requisitos WHERE prioridade = $1",
      [prioridade]
    );
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};
'@

# Conteúdo do requisitosProjetoController.js
$requisitosProjetoContent = @'
const pool = require("../../db");

// Listar todas as relações requisito-projeto
exports.index = async (req, res) => {
  try {
    const result = await pool.query(
      "SELECT rp.*, r.nome as requisito_nome, p.nome as projeto_nome " +
      "FROM requisitos_projeto rp " +
      "INNER JOIN requisitos r ON rp.requisito_id = r.id " +
      "INNER JOIN projetos p ON rp.projeto_id = p.id"
    );
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Salvar nova relação requisito-projeto
exports.store = async (req, res) => {
  try {
    const { requisito_id, projeto_id, status, data_inicio, data_fim } = req.body;
    const result = await pool.query(
      "INSERT INTO requisitos_projeto (requisito_id, projeto_id, status, data_inicio, data_fim) VALUES ($1, $2, $3, $4, $5) RETURNING *",
      [requisito_id, projeto_id, status, data_inicio, data_fim]
    );
    res.status(201).json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Buscar relação requisito-projeto por ID
exports.show = async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query(
      "SELECT rp.*, r.nome as requisito_nome, p.nome as projeto_nome " +
      "FROM requisitos_projeto rp " +
      "INNER JOIN requisitos r ON rp.requisito_id = r.id " +
      "INNER JOIN projetos p ON rp.projeto_id = p.id " +
      "WHERE rp.id = $1",
      [id]
    );
    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Relação requisito-projeto não encontrada" });
    }
    res.json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Atualizar relação requisito-projeto
exports.update = async (req, res) => {
  try {
    const { id } = req.params;
    const { requisito_id, projeto_id, status, data_inicio, data_fim } = req.body;
    const result = await pool.query(
      "UPDATE requisitos_projeto SET requisito_id=$1, projeto_id=$2, status=$3, data_inicio=$4, data_fim=$5 WHERE id=$6 RETURNING *",
      [requisito_id, projeto_id, status, data_inicio, data_fim, id]
    );
    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Relação requisito-projeto não encontrada" });
    }
    res.json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Deletar relação requisito-projeto
exports.delete = async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query("DELETE FROM requisitos_projeto WHERE id = $1 RETURNING *", [id]);
    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Relação requisito-projeto não encontrada" });
    }
    res.json({ message: "Relação requisito-projeto deletada com sucesso" });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Listar por projeto
exports.byProjeto = async (req, res) => {
  try {
    const { projetoId } = req.params;
    const result = await pool.query(
      "SELECT rp.*, r.nome as requisito_nome " +
      "FROM requisitos_projeto rp " +
      "INNER JOIN requisitos r ON rp.requisito_id = r.id " +
      "WHERE rp.projeto_id = $1",
      [projetoId]
    );
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Listar por requisito
exports.byRequisito = async (req, res) => {
  try {
    const { requisitoId } = req.params;
    const result = await pool.query(
      "SELECT rp.*, p.nome as projeto_nome " +
      "FROM requisitos_projeto rp " +
      "INNER JOIN projetos p ON rp.projeto_id = p.id " +
      "WHERE rp.requisito_id = $1",
      [requisitoId]
    );
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Listar por status
exports.byStatus = async (req, res) => {
  try {
    const { status } = req.params;
    const result = await pool.query(
      "SELECT rp.*, r.nome as requisito_nome, p.nome as projeto_nome " +
      "FROM requisitos_projeto rp " +
      "INNER JOIN requisitos r ON rp.requisito_id = r.id " +
      "INNER JOIN projetos p ON rp.projeto_id = p.id " +
      "WHERE rp.status = $1",
      [status]
    );
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};
'@

# Conteúdo do treinamentosController.js
$treinamentosContent = @'
const pool = require("../../db");

// Listar todos os treinamentos
exports.index = async (req, res) => {
  try {
    const result = await pool.query("SELECT * FROM treinamentos");
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Salvar novo treinamento
exports.store = async (req, res) => {
  try {
    const { nome, descricao, tipo, status, data_inicio, data_fim, instrutor_id } = req.body;
    const result = await pool.query(
      "INSERT INTO treinamentos (nome, descricao, tipo, status, data_inicio, data_fim, instrutor_id) VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING *",
      [nome, descricao, tipo, status, data_inicio, data_fim, instrutor_id]
    );
    res.status(201).json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Buscar treinamento por ID
exports.show = async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query("SELECT * FROM treinamentos WHERE id = $1", [id]);
    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Treinamento não encontrado" });
    }
    res.json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Atualizar treinamento
exports.update = async (req, res) => {
  try {
    const { id } = req.params;
    const { nome, descricao, tipo, status, data_inicio, data_fim, instrutor_id } = req.body;
    const result = await pool.query(
      "UPDATE treinamentos SET nome=$1, descricao=$2, tipo=$3, status=$4, data_inicio=$5, data_fim=$6, instrutor_id=$7 WHERE id=$8 RETURNING *",
      [nome, descricao, tipo, status, data_inicio, data_fim, instrutor_id, id]
    );
    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Treinamento não encontrado" });
    }
    res.json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Deletar treinamento
exports.delete = async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query("DELETE FROM treinamentos WHERE id = $1 RETURNING *", [id]);
    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Treinamento não encontrado" });
    }
    res.json({ message: "Treinamento deletado com sucesso" });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Listar treinamentos por status
exports.byStatus = async (req, res) => {
  try {
    const { status } = req.params;
    const result = await pool.query(
      "SELECT * FROM treinamentos WHERE status = $1",
      [status]
    );
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Listar treinamentos por instrutor
exports.byInstrutor = async (req, res) => {
  try {
    const { instrutor_id } = req.params;
    const result = await pool.query(
      "SELECT * FROM treinamentos WHERE instrutor_id = $1",
      [instrutor_id]
    );
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};
'@

# Conteúdo do testesController.js
$testesContent = @'
const pool = require("../../db");

// Listar todos os testes
exports.index = async (req, res) => {
  try {
    const result = await pool.query("SELECT * FROM testes");
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Salvar novo teste
exports.store = async (req, res) => {
  try {
    const { nome, descricao, tipo, status, projeto_id, data_inicio, data_fim } = req.body;
    const result = await pool.query(
      "INSERT INTO testes (nome, descricao, tipo, status, projeto_id, data_inicio, data_fim) VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING *",
      [nome, descricao, tipo, status, projeto_id, data_inicio, data_fim]
    );
    res.status(201).json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Buscar teste por ID
exports.show = async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query("SELECT * FROM testes WHERE id = $1", [id]);
    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Teste não encontrado" });
    }
    res.json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Atualizar teste
exports.update = async (req, res) => {
  try {
    const { id } = req.params;
    const { nome, descricao, tipo, status, projeto_id, data_inicio, data_fim } = req.body;
    const result = await pool.query(
      "UPDATE testes SET nome=$1, descricao=$2, tipo=$3, status=$4, projeto_id=$5, data_inicio=$6, data_fim=$7 WHERE id=$8 RETURNING *",
      [nome, descricao, tipo, status, projeto_id, data_inicio, data_fim, id]
    );
    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Teste não encontrado" });
    }
    res.json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Deletar teste
exports.delete = async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query("DELETE FROM testes WHERE id = $1 RETURNING *", [id]);
    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Teste não encontrado" });
    }
    res.json({ message: "Teste deletado com sucesso" });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Listar testes por projeto
exports.byProjeto = async (req, res) => {
  try {
    const { projeto_id } = req.params;
    const result = await pool.query(
      "SELECT * FROM testes WHERE projeto_id = $1",
      [projeto_id]
    );
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Listar testes por status
exports.byStatus = async (req, res) => {
  try {
    const { status } = req.params;
    const result = await pool.query(
      "SELECT * FROM testes WHERE status = $1",
      [status]
    );
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};
'@

# Conteúdo do tecnologiasProjetoController.js
$tecnologiasProjetoContent = @'
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
      return res.status(404).json({ message: "Tecnologia do projeto não encontrada" });
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
      return res.status(404).json({ message: "Tecnologia do projeto não encontrada" });
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
      return res.status(404).json({ message: "Tecnologia do projeto não encontrada" });
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
'@

# Conteúdo do tecnologiasController.js
$tecnologiasContent = @'
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
    const { nome, descricao, categoria, versao } = req.body;
    const result = await pool.query(
      "UPDATE tecnologias SET nome=$1, descricao=$2, categoria=$3, versao=$4 WHERE id=$5 RETURNING *",
      [nome, descricao, categoria, versao, id]
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
'@

# Criar os novos arquivos
Set-Content -Path "controllers\usuarios\usuariosController.js" -Value $usuariosContent -Encoding UTF8
Set-Content -Path "controllers\projetos\projetosController.js" -Value $projetosContent -Encoding UTF8
Set-Content -Path "controllers\clientes\clientesController.js" -Value $clientesContent -Encoding UTF8
Set-Content -Path "controllers\enderecos\enderecosController.js" -Value $enderecosContent -Encoding UTF8
Set-Content -Path "controllers\contribuidores\contribuidoresController.js" -Value $contribuidoresContent -Encoding UTF8
Set-Content -Path "controllers\contribuidoresProjeto\contribuidoresProjetoController.js" -Value $contribuidoresProjetoContent -Encoding UTF8
Set-Content -Path "controllers\documentos\documentosController.js" -Value $documentosContent -Encoding UTF8
Set-Content -Path "controllers\logs\logsController.js" -Value $logsContent -Encoding UTF8
Set-Content -Path "controllers\recursos\recursosController.js" -Value $recursosContent -Encoding UTF8
Set-Content -Path "controllers\recursosProjeto\recursosProjetoController.js" -Value $recursosProjetoContent -Encoding UTF8
Set-Content -Path "controllers\requisitos\requisitosController.js" -Value $requisitosContent -Encoding UTF8
Set-Content -Path "controllers\requisitosProjeto\requisitosProjetoController.js" -Value $requisitosProjetoContent -Encoding UTF8
Set-Content -Path "controllers\tecnologias\tecnologiasController.js" -Value $tecnologiasContent -Encoding UTF8
Set-Content -Path "controllers\tecnologiasProjeto\tecnologiasProjetoController.js" -Value $tecnologiasProjetoContent -Encoding UTF8
Set-Content -Path "controllers\testes\testesController.js" -Value $testesContent -Encoding UTF8
Set-Content -Path "controllers\treinamentos\treinamentosController.js" -Value $treinamentosContent -Encoding UTF8

Write-Host "Controllers recriados com sucesso!"