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

exports.delete = async (req, res) => {
  const { id } = req.params;
  const client = await pool.connect(); // Conecta ao pool para usar a transação

  try {
    await client.query('BEGIN'); // 1. Inicia a transação

    // 2. Pega o ID do endereço ANTES de deletar o cliente
    const enderecoResult = await client.query(
      "SELECT endereco_id FROM clientes WHERE id = $1",
      [id]
    );

    // Se o cliente não existir, o enderecoResult estará vazio
    if (enderecoResult.rows.length === 0) {
      // Importante: Damos rollback antes de sair
      await client.query('ROLLBACK');
      // Usamos 'return' para parar a execução aqui
      return res.status(404).json({ message: "Cliente não encontrado" });
    }
    
    const { endereco_id } = enderecoResult.rows[0];

    // 3. Deleta o cliente
    // (Removido RETURNING * pois não é necessário e já verificamos se existe)
    await client.query(
      "DELETE FROM clientes WHERE id = $1", 
      [id]
    );

    // 4. Deleta o endereço associado
    // Só deleta o endereço se ele existir (endereco_id não for nulo)
    if (endereco_id) {
      await client.query(
        "DELETE FROM enderecos WHERE id = $1", 
        [endereco_id]
      );
    }

    // 5. Se tudo deu certo, comita as mudanças
    await client.query('COMMIT'); 

    res.json({ message: "Cliente e endereço associado deletados com sucesso" });

  } catch (error) {
    // 6. Se algo deu errado (ex: erro de banco), desfaz tudo
    await client.query('ROLLBACK');
    res.status(500).json({ error: error.message });

  } finally {
    // 7. Libera a conexão de volta para o pool
    client.release();
  }
};


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